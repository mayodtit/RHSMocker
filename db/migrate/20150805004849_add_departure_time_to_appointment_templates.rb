class AddDepartureTimeToAppointmentTemplates < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :departure_time, :datetime
  end
end
