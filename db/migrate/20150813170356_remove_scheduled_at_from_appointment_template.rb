class RemoveScheduledAtFromAppointmentTemplate < ActiveRecord::Migration
  def up
    remove_column :appointment_templates, :scheduled_at
  end

  def down
    add_column :appointment_templates, :scheduled_at, :datetime
  end
end
