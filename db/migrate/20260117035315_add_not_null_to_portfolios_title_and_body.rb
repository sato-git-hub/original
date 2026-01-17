class AddNotNullToPortfoliosTitleAndBody < ActiveRecord::Migration[7.2]
  def change
    change_column_null :portfolios, :title, false
    change_column_null :portfolios, :body, false
  end
end
