class User < ApplicationRecord
  has_secure_password
  has_one :portfolio
  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
end