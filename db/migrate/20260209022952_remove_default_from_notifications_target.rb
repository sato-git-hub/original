class RemoveDefaultFromNotificationsTarget < ActiveRecord::Migration[7.2]
  def change
    change_column :notifications, :target, :integer, default: nil
  end
end
