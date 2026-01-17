class AddNotNullToRequests < ActiveRecord::Migration[7.2]
  def change
    change_column_null :requests, :title, false
    change_column_null :requests, :body, false
    change_column_null :requests, :current_amount, false
    change_column_default :requests, :current_amount, from: nil, to: "0"
    change_column_null :requests, :lowest_amount, false
    change_column_default :requests, :lowest_amount, from: nil, to: "0"
    change_column_null :requests, :target_amount, false
    change_column_default :requests, :target_amount, from: nil, to: "0"
    change_column_null :requests, :status, false
    change_column_default :requests, :status, from: nil, to: "0"
    change_column_null :requests, :approval_status, false
    change_column_default :requests, :approval_status, from: nil, to: "0"
  end
end
