class AddUserFacingToServices < ActiveRecord::Migration
  def change
    add_column :services, :user_facing, :boolean, default: false, null: false
    add_column :service_templates, :user_facing, :boolean, default: false, null: false
  end
end
