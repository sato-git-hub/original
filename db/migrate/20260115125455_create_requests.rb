class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :current_amount
      t.integer :lowest_amount
      t.integer :target_amount
      t.integer :status
      t.integer :approval_status

      t.timestamps
    end
  end
end
