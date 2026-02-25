class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :deposit, dependent: :destroy
  has_many :received_notifications,
            class_name: "Notification",
            foreign_key: :receiver_id,
            dependent: :destroy

  has_many :support_histories, dependent: :destroy
  has_many :received_requests,
           class_name: "Request",
           foreign_key: :creator_id,
           dependent: :destroy

  has_one :creator_setting, dependent: :destroy

  # 　複数のリクエストを持つ　　user.request
  has_many :requests, dependent: :destroy

  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :name, presence: true

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
    "unacceptable_brand" => "対象のカードブランドが許可されていません",
    "already_have_card" => "このカードは既に登録されています"
  }.freeze

  # カード登録
  def register_card(payjp_token)
    if self.payjp_customer_id.present?
      customer = Payjp::Customer.retrieve(payjp_customer_id)
      customer.card = payjp_token
      customer.save
      begin
      update!(last4: customer.cards.data[0].last4)
      Rails.logger.debug "DEBUG:  ID=#{self.last4}"
      Rails.logger.debug "DEBUG: 更新完了 ID=#{payjp_customer_id}"
      rescue => e
        customer.delete
        raise e
      end
    else
      customer = Payjp::Customer.create(
        card: payjp_token,
        description: "User ID: #{self.id}",
        email: self.email
      )
      begin
      update!(payjp_customer_id: customer.id, last4: customer.cards.data[0].last4)
      Rails.logger.debug "DEBUG: 新規登録完了 ID=#{customer.id}"
      Rails.logger.debug "DEBUG: 新規登録完了 ID=#{self.last4}"
      rescue => e
        customer.delete
        raise e
      end
    end
  rescue Payjp::PayjpError => e
    # 左側の処理でエラーが起きたら、例外を投げずに nilを返す
    # rescue => eに飛ばないため
    error_code = e.json_body[:error][:code] rescue nil
    ja_message = PAYJP_ERROR_CODE[error_code] || "カード登録に失敗しました"
      raise ja_message
  rescue => e
    raise "システムエラーが発生しました"
  end
end
