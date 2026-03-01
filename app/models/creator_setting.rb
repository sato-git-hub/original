class CreatorSetting < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :images,
                    content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "png, jpg, jpegいずれかの形式にして下さい" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

                    
  def self.ransackable_attributes(auth_object = nil)
    %w[
      user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[]
  end

end

