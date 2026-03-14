class ChangePrecisionOfDeliveryDueDateAndDeliveredAtToRequests < ActiveRecord::Migration[7.2]
  def change
    change_column :requests, :delivery_due_date, :datetime, precision: nil
    change_column :requests, :delivered_at, :datetime, precision: nil
  end
end
