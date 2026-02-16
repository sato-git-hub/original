class AddColumnPayjpChageIdAndStatusToSupportHistories < ActiveRecord::Migration[7.2]
  def change
    add_column :support_histories, :payjp_charge_id, :string, null: false, default: ""
    add_column :support_histories, :status, :integer, null: false, default: 0
  end
end
