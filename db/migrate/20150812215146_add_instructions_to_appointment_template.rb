class AddInstructionsToAppointmentTemplate < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :special_instructions, :text
  end
end
