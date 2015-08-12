class AddReasonToAppointmentTemplate < ActiveRecord::Migration
  def change
    add_column :appointment_templates, :reason_for_visit, :text
  end
end
