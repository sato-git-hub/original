class AddColumnHasShippingToRewards < ActiveRecord::Migration[7.2]
  def change
    add_column :rewards, :has_shipping, :boolean, null: false, default: false
  end
end
