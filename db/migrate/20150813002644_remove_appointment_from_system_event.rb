class RemoveAppointmentFromSystemEvent < ActiveRecord::Migration
  def up
    remove_column :system_events, :appointment_id
  end

  def down
    add_column :system_events, :appointment_id, :integer
  end
end
