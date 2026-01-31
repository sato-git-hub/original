class AddSearchConfToRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :requests, :search_conf, :text
  end
end
