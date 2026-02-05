class Request < ApplicationRecord
  before_save :set_search_conf
  # validate :editable_only_when_draft, on: :update

  scope :search, ->(keyword) {
    keywords = keyword.split(/[ 　]+/)
    relation = all
    keywords.each do |k|
    sanitized = "%#{ActiveRecord::Base.sanitize_sql_like(k)}%"
    relation = relation.where("title LIKE ? OR body LIKE ?", sanitized, sanitized)
   end
   relation
}



# jobが失敗してstatusがfinishedまたはsuccess_finishedに切り替わらなかった時用
scope :active, -> {
    where("deadline_at > ?", Time.current.floor)
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      title
      search_conf
      character
      status
    ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[character]
  end

  has_many :notifications, dependent: :destroy 
  has_one :character, dependent: :destroy
  accepts_nested_attributes_for :character
  has_many :support_histories, dependent: :destroy
  belongs_to :user
  belongs_to :creator, class_name: "User"
  validates :user, :creator, presence: true

    enum :status, {
  draft: 0, # 下書き
  submit: 1, # クリエーターに送信済みで承認待ち
  approved: 2, # クリエーター承認済み
  creator_declined: 3, # クリエーターがリクエストを拒否
  succeeded: 4,
  finished: 5,
  success_finished: 6
}
  # リクエスト画像
  has_many_attached :request_images
  validates :request_images,
                    content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :title, :body, :target_amount, presence: true, on: :create

  def submit!
    raise "invalid state" unless draft?
    update!(status: :submit)
  end

  def approve!
    raise "invalid state" unless submit?
      # update!(status: :approved, approved_at: Time.current.floor, deadline_at: 30.seconds.from_now)は成功
      update!(status: :approved, approved_at: Time.current.floor, deadline_at: Time.current.floor + 30.days)

      # update！とすることで更新失敗時には下の処理が呼ばれる前に例外を返す　CloseProjectJobは作られない
      CloseProjectJob.set(wait_until: self.deadline_at).perform_later(self.id)
      self.notifications.create!(action: :approved, receiver: self.user)
  end

  def decline!
    raise "invalid state" unless submit?
    update!(status: :creator_declined)
  end

  def mark_success_if_reached!
    return unless approved?
    return unless target_amount <= current_amount
    update!(status: :succeeded)
  end

  def finish_if_expired!
    return unless Time.current.floor >= deadline_at
    # 期間が過ぎた時にどっちになるか判定
    if succeeded?
      update!(status: :success_finished)
    elsif approved?
      update!(status: :finished)
    end
  end
PAYJP_ERROR_CODE = {
    'invalid_number' => 'カード番号が不正です',
    'invalid_cvc' => 'CVCが不正です',
    'invalid_expiration_date' => '有効期限年、または月が不正です',
    'incorrect_card_data' => 'カード番号、有効期限、CVCのいずれかが不正です',
    'invalid_expiry_month' => '有効期限月が不正です',
    'invalid_expiry_year' => '有効期限年が不正です',
    'expired_card' => '有効期限切れです',
    'card_declined' => 'カード会社によって拒否されたカードです',
    'processing_error' => '決済ネットワーク上でエラーが発生しました',
    'missing_card' => '顧客がカードを保持していない',
    'unacceptable_brand' => '対象のカードブランドが許可されていません'
  }.freeze

def support!(user:, amount:, payjp_token:)
  raise "支払い情報がありません" if payjp_token.blank? && user.payjp_customer_id.blank?
  raise ArgumentError, "最低金額以上で入力してください" unless amount >= lowest_amount

  begin
  if payjp_token.nil? 

    charge = Payjp::Charge.create(
      amount: amount,
      customer: user.payjp_customer_id, 
      currency: "jpy",
      capture: false,
      expiry_days: 60
    )

  else
    charge = Payjp::Charge.create(
      amount: amount,
      card: payjp_token,
      currency: "jpy",
      capture: false,
      expiry_days: 60
    )
  end

    transaction do
      lock!
      support_histories.create!(
        user: user,
        amount: amount,
        payjp_charge_id: charge.id,
        status: :authorized #省略可
      )

      self.current_amount += amount
      save!
      mark_success_if_reached!
    end
  rescue Payjp::PayjpError => e
  Rails.logger.debug "DEBUG: keyword=#{e.json_body}"# #{e}はDEBUG: keyword=(Status 402) Card declinedとなった
  Rails.logger.debug "DEBUG: keyword=#{e.methods.sort}"
  #{e.json_body}はDEBUG: keyword={:error=>{:charge=>"ch_e72d27cb0fe9ff942dda9b8974bbf", :code=>"card_declined", :message=>"Card declined", :status=>402, :type=>"card_error"}}となった
  error_code = e.json_body[:error][:code] rescue nil
  ja_message = PAYJP_ERROR_CODE[error_code] || "決済処理に失敗しました"
  raise ja_message
  rescue => e
    charge&.refund
    raise RunTimeError, "決済処理に失敗しました" # RnuTimeErrorは省略可
  end
end

  def set_search_conf
    return if title.blank?
    nm = Natto::MeCab.new
    yomi_katakana = []
    moto = []
    allowed = %w[一般 固有名詞 サ変接続 形容動詞語幹]
    nm.parse(self.title) do |n|
      next if n.is_eos?
      next unless  n.feature[0] == "名"
      if allowed.include?(n.feature.split(",")[1])
         moto << n.surface
         yomi = n.feature.split(",")[7]
         if  yomi.present? && yomi != "*"
         yomi_katakana << yomi
         else
         yomi_katakana << n.surface
         end
      end
      end

    yomi_hiragana = yomi_katakana.map { |v|v.tr("ァ-ン", "ぁ-ん") }

    self.search_conf = [
      moto,
      yomi_katakana,
      yomi_hiragana
    ].flatten.uniq.join(" ")
  end
end