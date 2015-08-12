class AddAppointmentColumnToSystemEvents < ActiveRecord::Migration
  def change
    add_column :system_events, :appointment_id, :integer
  end
end
