class AddColumnDeliveryDueDateToRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :requests, :delivery_due_date, :datetime
  end
end
