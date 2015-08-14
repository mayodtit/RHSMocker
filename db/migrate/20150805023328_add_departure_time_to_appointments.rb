class AddDepartureTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :departure_time, :datetime
  end
end
