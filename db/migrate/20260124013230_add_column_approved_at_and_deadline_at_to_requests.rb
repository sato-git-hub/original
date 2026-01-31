class AddColumnApprovedAtAndDeadlineAtToRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :requests, :approved_at, :datetime, precision: 0
    add_column :requests, :deadline_at, :datetime, precision: 0
  end
end
