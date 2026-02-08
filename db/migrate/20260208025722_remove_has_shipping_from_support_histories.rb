class RemoveHasShippingFromSupportHistories < ActiveRecord::Migration[7.2]
  def change
    remove_column :support_histories, :has_shipping, :boolean
  end
end
