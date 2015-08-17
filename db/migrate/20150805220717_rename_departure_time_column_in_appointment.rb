class RenameDepartureTimeColumnInAppointment < ActiveRecord::Migration
  def change
    rename_column :appointments, :departure_time, :departed_at
  end
end
