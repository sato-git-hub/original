class RemoveFacebookFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :facebook, :string
  end
end
