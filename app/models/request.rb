class Request < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: "User"
  has_many_attached :request_images #リクエスト画像
  validates :request_images,
                    attached: true, #presence: true
                    content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :title, :body, presence: true, on: :create
end
