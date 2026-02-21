class RemovePublishedFromRequests < ActiveRecord::Migration[7.2]
  def change
    remove_column :requests, :published, :boolean
  end
end
