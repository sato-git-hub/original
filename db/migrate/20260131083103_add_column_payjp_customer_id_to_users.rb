class AddColumnPayjpCustomerIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :payjp_customer_id, :string 
  end
end
