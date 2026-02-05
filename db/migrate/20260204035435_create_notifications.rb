class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.boolean :checked, null: false, default: false
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :sender, foreign_key: { to_table: :users }
      t.references :request, null: false, foreign_key: true
      t.integer :action, null: false
      t.timestamps
    end
  end
end
