class CreatePortfolios < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolios do |t|
      t.string :title
      t.text :body
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
