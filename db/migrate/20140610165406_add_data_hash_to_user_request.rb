class AddDataHashToUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :request_data, :text
  end
end
