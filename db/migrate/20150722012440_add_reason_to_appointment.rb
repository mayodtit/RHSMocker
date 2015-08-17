class AddReasonToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :reason, :string
  end
end
