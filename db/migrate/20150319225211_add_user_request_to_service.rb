class AddUserRequestToService < ActiveRecord::Migration
  def change
    add_column :services, :user_request, :text
  end
end
