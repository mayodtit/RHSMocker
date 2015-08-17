class AddAppointmentTemplateIdToSystemEventTemplate < ActiveRecord::Migration
  def change
    add_column :system_event_templates, :appointment_template_id, :integer
  end
end
