class AddRewardRefToSupportHistories < ActiveRecord::Migration[7.2]
  def change
    add_reference :support_histories, :reward, null: false, foreign_key: true
  end
end
