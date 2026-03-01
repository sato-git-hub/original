class CreateDeposits < ActiveRecord::Migration[7.2]
  def change
    create_table :deposits do |t|
      t.string :bank_name, null: false
      t.string :account_number, null: false
      t.string :account_holder, null: false
      t.string :branch_name, null: false
      t.string :radio_group, null: false

      t.timestamps
    end
  end
end
