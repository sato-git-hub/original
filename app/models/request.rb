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
      status
    ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[]
  end

  has_many :rewards, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :support_histories, dependent: :destroy
  belongs_to :user
  belongs_to :creator, class_name: "User"
  validates :user, :creator, presence: true

  # 複数の子要素に対して処理したいとき 「Userの新規登録と同時に、そのUserの最初のPostを1つだけ作る」といったケースでは、使わない
  # assign_attributes、updateがparams[:"0"]つまり{0=>{}}こういうハッシュを受け取れるようにする働き
  # allow_destroy: true　親モデルのフォームで子モデルの削除を許可 params[:_destroy]というデータが送られてきたら
  # reject_if: :all_blank 空の子モデルを自動的に拒否　送られてきたハッシュの中身がすべて空（nilや空文字）だった場合無視
  accepts_nested_attributes_for :rewards, allow_destroy: true, reject_if: :all_blank


    enum :status, {
  draft: 0, # 下書き
  submit: 1, # クリエーターに送信済みで承認待ち
  approved: 2, # クリエーター承認済み
  creator_declined: 3, # クリエーターがリクエストを拒否
  succeeded: 4,
  finished: 5,
  success_finished: 6,
  completed: 7
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
    self.notifications.create!(action: :submit, receiver: self.creator, target: :creator)
  end

  def approve!(request_params)
    raise "invalid state" unless submit?
    transaction do
      Rails.logger.debug "DEBUG: keyword=#{request_params}"
      update!(status: :approved, approved_at: Time.current.floor, deadline_at: 2.minutes.from_now)
      # update!(status: :approved, approved_at: Time.current.floor, deadline_at: Time.current.floor + 30.days)

      # 送られてきた番号ハッシュ = 1つのレコード をつくる
      self.assign_attributes(request_params)
      self.save!
      # selfはリクエストレコード
      Rails.logger.debug "DEBUG: keyword=#{self.inspect}"
      CloseProjectJob.set(wait_until: self.deadline_at).perform_later(self.id)
      self.notifications.create!(action: :approved, receiver: self.user, target: :supporter)
    end
  end

  def decline!
    raise "invalid state" unless submit?
    update!(status: :creator_declined)
    self.notifications.create!(action: :decline, receiver: self.user, target: :supporter)
  end

  def complete!
    raise "invalid state" unless success_finished?
    update!(status: :completed)
    self.notifications.create!(action: :completed, receiver: self.creator, target: :creator)
  end

  def mark_success_if_reached!
    return unless approved?
    return unless target_amount <= current_amount
    update!(status: :succeeded)
    self.notifications.create!(action: :succeeded, receiver: self.user, target: :supporter)
    self.notifications.create!(action: :succeeded, receiver: self.creator, target: :creator)
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
    "invalid_number" => "カード番号が不正です",
    "invalid_cvc" => "CVCが不正です",
    "invalid_expiration_date" => "有効期限年、または月が不正です",
    "incorrect_card_data" => "カード番号、有効期限、CVCのいずれかが不正です",
    "invalid_expiry_month" => "有効期限月が不正です",
    "invalid_expiry_year" => "有効期限年が不正です",
    "expired_card" => "有効期限切れです",
    "card_declined" => "カード会社によって拒否されたカードです",
    "processing_error" => "決済ネットワーク上でエラーが発生しました",
    "missing_card" => "顧客がカードを保持していない",
    "unacceptable_brand" => "対象のカードブランドが許可されていません"
  }.freeze

def support!(user:, reward_id:, payjp_token:)
  raise "支払い情報がありません" if payjp_token.blank? && user.payjp_customer_id.blank?

  begin
    reward = Reward.find(reward_id)

    if payjp_token.present?
      customer = Payjp::Customer.create(card: payjp_token)
      user.update!(payjp_customer_id: customer.id)
      customer_id = customer.id
    else
      customer_id = user.payjp_customer_id
    end

    charge = Payjp::Charge.create(
      amount: reward.amount,
      customer: customer_id,
      currency: "jpy",
      capture: false,
      expiry_days: 60
    )

    transaction do
      lock!
      support_histories.update!(
        payjp_charge_id: charge.id,
      )

      self.current_amount += reward.amount
      save!
      mark_success_if_reached!
    end
    rescue Payjp::PayjpError => e
      Rails.logger.debug "DEBUG: keyword=#{e.json_body}"
      error_code = e.json_body.dig(:error, :code)
      ja_message = PAYJP_ERROR_CODE[error_code] || "決済処理に失敗しました"
      raise ja_message
    rescue => e
      charge&.refund
      Rails.logger.error "DEBUG: keyword=#{e.full_message}=================="
      raise "予期しないエラーが発生しました"
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
