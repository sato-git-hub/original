class RecreateUserReferenceOnPortfolios < ActiveRecord::Migration[7.2]
  def change
    remove_column :portfolios, :user_id
    add_reference :portfolios, :user, null: false, foreign_key: true
  end
end
