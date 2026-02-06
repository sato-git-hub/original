class Reward < ApplicationRecord
  belongs_to :request
  has_many :support_histories, dependent: :destroy
  
  has_one_attached :reward_image
  validates :reward_image,
                    content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :title, :body, :amount, presence: true, on: :create

end
