class RenameServiceUserRequest < ActiveRecord::Migration
  def up
    rename_column :services, :user_request, :service_request
  end

  def down
    rename_column :services, :service_request, :user_request
  end
end
