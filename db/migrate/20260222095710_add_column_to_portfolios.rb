class AddColumnToPortfolios < ActiveRecord::Migration[7.2]
  def change
    add_column :portfolios, :minimum_amount, :integer, default: 1000, null: false
    add_column :portfolios, :minimum_supporters, :integer, default: 1, null: false
  end
end
