class AllowNilToRoleForPhoneCall < ActiveRecord::Migration
  def up
    change_column :phone_calls, :to_role_id, :integer, :null => true
  end

  def down
    nurse_role = Role.find_by_name! :nurse
    execute "UPDATE phone_calls SET to_role_id=#{nurse_role.id} WHERE to_role_id=NULL"
    change_column :phone_calls, :to_role_id, :integer, :null => false
  end
end
