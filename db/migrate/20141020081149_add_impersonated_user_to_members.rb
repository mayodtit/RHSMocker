class AddImpersonatedUserToMembers < ActiveRecord::Migration
  def change
    add_column :users, :impersonated_user_id, :integer
  end
end
