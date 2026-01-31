class RenameCommentsToUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :comments, :comment
    change_column_default :users, :comment, from: nil, to: ""
  end
end
