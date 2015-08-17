class RemoveOwnerIdFromAppointments < ActiveRecord::Migration
  def up
    remove_column :appointments, :owner_id
  end

  def down
    add_column :appointments, :owner_id, :integer
  end
end
