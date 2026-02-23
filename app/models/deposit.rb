class Deposit < ApplicationRecord
  belongs_to :user
  validates :bank_name, :account_number, :account_holder, :branch_name, :radio_group, presence: true
end
