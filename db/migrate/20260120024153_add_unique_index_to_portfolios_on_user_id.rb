class AddUniqueIndexToPortfoliosOnUserId < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :portfolios, :users
    remove_index :portfolios, :user_id

    add_index :portfolios, :user_id, unique: true
    add_foreign_key :portfolios, :users
  end
end
