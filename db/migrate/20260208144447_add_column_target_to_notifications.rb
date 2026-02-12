class AddColumnTargetToNotifications < ActiveRecord::Migration[7.2]
  def change
    add_column :notifications, :target, :integer, default: 0, null: false
  end
end
