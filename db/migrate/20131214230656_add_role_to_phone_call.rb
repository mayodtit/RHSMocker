class AddRoleToPhoneCall < ActiveRecord::Migration
  def up
    nurse_role = Role.find_by_name! :nurse
    add_column :phone_calls, :to_role_id, :integer, :null => false, :default => nurse_role.id
    PhoneCall.update_all ['to_role_id = ?', nurse_role.id]
    add_index :phone_calls, :to_role_id
  end

  def down
    remove_column :phone_calls, :to_role_id
  end
end