class CreateCreatorSettings < ActiveRecord::Migration[7.2]
  def change

    create_table :creator_settings, force: :cascade do |t|
      t.text "body", null: false
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.boolean "published", default: false, null: false
      t.integer "minimum_amount", default: 1000, null: false
      t.integer "minimum_supporters", default: 1, null: false
      t.timestamps

    end
  end
end
