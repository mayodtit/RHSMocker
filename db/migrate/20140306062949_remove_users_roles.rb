class RemoveUsersRoles < ActiveRecord::Migration
  def up
    drop_table :users_roles
  end

  def down
    create_table :users_roles, :id => false do |t|
      t.integer :user_id
      t.integer :role_id
    end
    add_index "users_roles", ["user_id", "role_id"]
  end
end
