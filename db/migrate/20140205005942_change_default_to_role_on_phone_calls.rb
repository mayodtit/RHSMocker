class ChangeDefaultToRoleOnPhoneCalls < ActiveRecord::Migration
  def up
    pha_role = Role.find_by_name! :pha
    change_column :phone_calls, :to_role_id, :integer, default: pha_role.id
  end

  def down
    nurse_role = Role.find_by_name! :nurse
    change_column :phone_calls, :to_role_id, :integer, default: nurse_role.id
  end
end
