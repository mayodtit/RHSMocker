class RenameArrivalTimeColumnInAppointment < ActiveRecord::Migration
  def change
    rename_column :appointments, :arrival_time, :arrived_at
  end
end
