class AddUserIdToDeposit < ActiveRecord::Migration[7.2]
  def change
    add_reference :deposits, :user, null: false, foreign_key: true
  end
end
