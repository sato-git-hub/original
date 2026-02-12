class ChangeColumnToAllowNull < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :last4, :string, null: true
  end
end
