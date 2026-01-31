class User < ApplicationRecord
  has_secure_password
  
  has_many :received_requests,
           class_name: "Request",
           foreign_key: :creator_id, 
           dependent: :destroy
           
  has_one :portfolio, dependent: :destroy
  
  #　複数のリクエストを持つ　　user.request 
  has_many :requests, dependent: :destroy
  
  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :name, presence: true
end