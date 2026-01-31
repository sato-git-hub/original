class AddColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :comments, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :pixiv, :string
  end
end
