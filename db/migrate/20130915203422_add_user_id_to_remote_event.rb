class AddUserIdToRemoteEvent < ActiveRecord::Migration
  def change
    add_column :remote_events, :user_id, :integer
  end
end
