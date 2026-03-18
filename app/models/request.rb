class Request < ApplicationRecord
  before_save :set_search_conf
  # 納品期日前のリクエスト
  scope :active_deadline, -> { where("delivery_due_date > ?", Time.current.floor) }
  # 納品期日が過去のリクエスト
  scope :expired, -> { where("delivery_due_date < ?", Time.current.floor) } 
  # 納品期日を守ったリクエスト
  scope :on_time, -> { where("delivered_at <= delivery_due_date") }
  # 納品期日を守らなかったリクエスト
  scope :off_time, -> { where("delivered_at > delivery_due_date") }

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

# 1. 公開中（承認済み、または成功）
scope :publish, -> { where(status: [:approved, :succeeded]) }

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
  # request_idが該当のsupport_historyレコード、そのレコードのuser_idからuserインスタンスを取り出す

  has_many :notifications, dependent: :destroy
  has_many :support_histories, dependent: :destroy
  belongs_to :user
  belongs_to :creator, class_name: "User"
  has_many :supporters, through: :support_histories, source: :user
  validates :user, :creator, presence: true

  # 複数の子要素に対して処理したいとき 「Userの新規登録と同時に、そのUserの最初のPostを1つだけ作る」といったケースでは、使わない
  # assign_attributes、updateがparams[:"0"]つまり{0=>{}}こういうハッシュを受け取れるようにする働き
  # allow_destroy: true　親モデルのフォームで子モデルの削除を許可 params[:_destroy]というデータが送られてきたら
  # reject_if: :all_blank 空の子モデルを自動的に拒否　送られてきたハッシュの中身がすべて空（nilや空文字）だった場合無視

    enum :status, {
  draft: 0, # 下書き
  submit: 1, # クリエーターに送信済みで承認待ち
  approved: 2, # クリエーター承認済み
  creator_declined: 3, # クリエーターがリクエストを拒否
  succeeded: 4,
  finished: 5,
  success_finished: 6,
  expired: 7, # 納品期日を過ぎた
  completed: 8 # クリエーターが納品を完了(期日内)
}


  # 納品イラストファイル
  has_one_attached :deliverable_psd
  validates :deliverable,
                    content_type: { in: %w[image/jpeg image/gif image/png image/webp image/vnd.adobe.photoshop ],
                    message: "psd, png, jpg, jpeg, gif, webp いずれかの形式にして下さい" },
                    size: { less_than: 500.megabytes, message: " 500MBを超えるファイルはアップロードできません" }

  # 納品イラスト サムネイル用
  has_one_attached :deliverable
  validates :deliverable,
                    content_type: { in: %w[image/jpeg image/gif image/png image/webp ],
                    message: "png, jpg, jpeg, gif, webp いずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  with_options on: :step1 do
    validates :deliverable_thumbnail,
                      presence: true
  end

  # リクエスト画像
  has_many_attached :request_images
  validates :request_images,
                    presence: true,
                    content_type: { in: %w[image/jpeg image/gif image/png image/webp],
                    message: "png, jpg, jpeg, gif, webp いずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :title, :body, :target_amount, presence: true, on: :create


  def supporters_count
    if support_histories.loaded?
      support_histories.map(&:user_id).uniq.size
    else
      support_histories.distinct.count(:user_id)
    end
  end

  def submit!
    raise "invalid state" unless draft?
    update!(status: :submit)
    self.notifications.create!(action: :submit, receiver: self.creator, target: :creator)
  end

  def approve!
    raise "invalid state" unless submit?
    transaction do
      update!(status: :approved, approved_at: Time.current.floor, deadline_at: 2.minutes.from_now)
      #update!(status: :approved, approved_at: Time.current.floor, deadline_at: Time.current.floor + 30.days)

      # selfはリクエストレコード
      Rails.logger.debug "DEBUG: keyword=#{self.inspect}"
      CloseRequestJob.set(wait_until: self.deadline_at).perform_later(self.id)
      self.notifications.create!(action: :approved, receiver: self.user, target: :supporter)
    end
  end

  def decline!
    raise "invalid state" unless submit?
    update!(status: :creator_declined)
    self.notifications.create!(action: :decline, receiver: self.user, target: :supporter)
  end

  def finished!
    transaction do
      update!(status: :finished)
      self.notifications.create!(action: :finished, receiver: self.user, target: :supporter)
      self.notifications.create!(action: :finished, receiver: self.creator, target: :creator)
    end
  end

  def success_finished!
    transaction do
      update!(status: :success_finished, delivery_due_date: Time.current.floor + self.creator.creator_setting.delivery_deadline.days)
      self.notifications.create!(action: :success_finished, receiver: self.user, target: :supporter)
      self.notifications.create!(action: :success_finished, receiver: self.creator, target: :creator)
      # self.notifications.create!(action: :, receiver: self.user, target: :supporter)
    end
  end

  # 納品完了
  def complete!(deliverable_params)
    raise "already completed" if completed?
    transaction do
      update!(deliverable_params.merge(status: :completed, delivered_at: Time.current.floor))
      self.notifications.create!(action: :completed, receiver: self.user, target: :supporter)
      self.notifications.create!(action: :completed, receiver: self.creator, target: :creator)
    end
  end

  def mark_success_if_reached!
    return unless approved?
    return unless self.creator.creator_setting.minimum_supporters <= self.supporters_count
    return unless target_amount <= current_amount
    update!(status: :succeeded)
    self.notifications.create!(action: :succeeded, receiver: self.user, target: :supporter)
    self.notifications.create!(action: :succeeded, receiver: self.creator, target: :creator)
  end

  def finish_if_expired!
    return unless Time.current.floor >= deadline_at
    if succeeded?
      success_finished!
    elsif approved?
      finished!
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

def support!(user:, amount:, payjp_token:, support_history:)
  raise "支払い情報がありません" if payjp_token.blank? && user.payjp_customer_id.blank?
  amount = amount.to_i
  begin

    if payjp_token.present?
      customer = Payjp::Customer.create(card: payjp_token)
      user.update!(payjp_customer_id: customer.id)
      customer_id = customer.id
    else
      customer_id = user.payjp_customer_id
    end

    charge = Payjp::Charge.create(
      amount: amount,
      customer: customer_id,
      currency: "jpy",
      capture: false,
      expiry_days: 60
    )

    transaction do
      lock!
      support_history.update!(
        payjp_charge_id: charge.id,
      )

      self.current_amount += amount
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
