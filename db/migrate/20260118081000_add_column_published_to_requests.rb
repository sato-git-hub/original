class AddColumnPublishedToRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :requests, :published, :boolean, null: false, default: false
  end
end
