class AddArrivalTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :arrival_time, :datetime
  end
end
