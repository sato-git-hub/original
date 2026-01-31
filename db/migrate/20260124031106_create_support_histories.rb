class CreateSupportHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :support_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
