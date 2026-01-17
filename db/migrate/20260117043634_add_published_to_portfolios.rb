class AddPublishedToPortfolios < ActiveRecord::Migration[7.2]
  def change
    add_column :portfolios, :published, :boolean, null: false, default: false
  end
end
