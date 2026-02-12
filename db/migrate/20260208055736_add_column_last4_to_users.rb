class AddColumnLast4ToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :last4, :string, null: false
  end
end
