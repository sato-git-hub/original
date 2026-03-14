class AddColumnDeliveryDeadlineToCreatorSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :creator_settings, :delivery_deadline, :integer, null: false
  end
end
