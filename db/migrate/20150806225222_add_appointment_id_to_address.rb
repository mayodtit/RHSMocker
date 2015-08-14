class AddAppointmentIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :appointment_id, :integer
  end
end
