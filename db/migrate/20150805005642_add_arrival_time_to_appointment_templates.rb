class AddArrivalTimeToAppointmentTemplates < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :arrival_time, :datetime
  end
end
