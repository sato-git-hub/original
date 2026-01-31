class AddColumnUserIdToRevisions < ActiveRecord::Migration[7.2]
  def change
     add_reference :revisions, :user, null: false, foreign_key: true
  end
end
