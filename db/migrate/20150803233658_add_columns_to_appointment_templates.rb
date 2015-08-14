class AddColumnsToAppointmentTemplates < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :unique_id, :string
    add_column :appointment_templates, :state, :string
    add_column :appointment_templates, :version, :integer, default: 0, null: false
  end
end
