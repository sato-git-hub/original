class AddColumnUserNameToSuppoerHistories < ActiveRecord::Migration[7.2]
  def change
    add_column :support_histories, :user_name, :string, null: true
  end
end
