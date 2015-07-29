class RemoveAttributesFromAppointmentChanges < ActiveRecord::Migration
  def up
    remove_column :appointment_changes, :event
    remove_column :appointment_changes, :from
    remove_column :appointment_changes, :to
  end

  def down
    add_column :appointment_changes, :event, :string
    add_column :appointment_changes, :from, :string
    add_column :appointment_changes, :to, :string
  end
end
