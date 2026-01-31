class CreateRevisionRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :revision_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :sender_type, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
