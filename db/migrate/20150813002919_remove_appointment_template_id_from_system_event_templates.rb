class RemoveAppointmentTemplateIdFromSystemEventTemplates < ActiveRecord::Migration
  def up
    remove_column :system_event_templates, :appointment_template_id
  end

  def down
    add_column :system_event_templates, :appointment_template_id, :integer
  end
end
