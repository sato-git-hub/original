class AddColumnToSupportHistories < ActiveRecord::Migration[7.2]
  def change
    add_column :support_histories, :shipping_postal_code, :string
    add_column :support_histories, :shipping_prefecture, :integer
    add_column :support_histories, :shipping_city, :string
    add_column :support_histories, :shipping_address_line1, :string
    add_column :support_histories, :shipping_address_line2, :string
    add_column :support_histories, :shipping_phone_number, :string
  end
end
