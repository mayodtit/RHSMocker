class AddColumnToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :appointment_template_id, :integer
  end
end
