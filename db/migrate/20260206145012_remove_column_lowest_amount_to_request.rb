class RemoveColumnLowestAmountToRequest < ActiveRecord::Migration[7.2]
  def change
    remove_column :requests, :lowest_amount, :integer
  end
end
