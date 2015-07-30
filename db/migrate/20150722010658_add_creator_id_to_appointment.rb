class AddCreatorIdToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :creator_id, :integer
  end
end
