class AddAttributesToAppointmentTemplate < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :name, :string
    add_column :appointment_templates, :title, :string
    add_column :appointment_templates, :description, :text
  end
end
