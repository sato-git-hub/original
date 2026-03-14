class AddColumnDeliveredAtToRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :requests, :delivered_at, :datetime
  end
end
