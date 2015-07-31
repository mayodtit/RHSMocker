class RemoveReasonFromAppointmentChanges < ActiveRecord::Migration
  def up
    remove_column :appointment_changes, :reason
  end

  def down
    add_column :appointment_changes, :reason, :string
  end
end
