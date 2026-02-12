class CreateRewards < ActiveRecord::Migration[7.2]
  def change
    create_table :rewards do |t|
      t.references :request, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.integer :amount, null: false
      t.integer :stock
      t.timestamps
    end
  end
end
