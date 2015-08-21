class RemoveNameFromAppointmentTemplates < ActiveRecord::Migration
  def up
    remove_column :appointment_templates, :name
  end

  def down
    add_column :appointment_templates, :name, :string
  end
end
