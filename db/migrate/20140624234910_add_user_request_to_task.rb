class AddUserRequestToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :user_request_id, :integer
  end
end
