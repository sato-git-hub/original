class CreatorSetting < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :images,
    content_type: { in: %w[image/jpeg image/gif image/png image/webp],
      message: "png, jpg, jpeg, gif, webp いずれかの形式にして下さい" },
    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

    attr_accessor :terms_agreed
    validates :terms_agreed, acceptance: true

    validates :images, presence: true
    validates :delivery_deadline, inclusion: { in: 1..100 }
    validates :minimum_amount, inclusion: { in: 300..50000 }
    validates :minimum_supporters, inclusion: { in: 1..100 }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[]
  end

end

