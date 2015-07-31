class AddUserFacingToSuggestedServices < ActiveRecord::Migration
  def change
    add_column :suggested_services, :user_facing, :boolean
  end
end
