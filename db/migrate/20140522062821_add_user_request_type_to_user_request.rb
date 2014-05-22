class AddUserRequestTypeToUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :user_request_type_id, :integer
  end
end
