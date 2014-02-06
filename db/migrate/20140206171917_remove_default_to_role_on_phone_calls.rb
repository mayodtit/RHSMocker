class RemoveDefaultToRoleOnPhoneCalls < ActiveRecord::Migration
  def up
    change_column_default :phone_calls, :to_role_id, nil
  end

  def down
    change_column_default :phone_calls, :to_role_id, Role.find_by_name!(:pha).id
  end
end