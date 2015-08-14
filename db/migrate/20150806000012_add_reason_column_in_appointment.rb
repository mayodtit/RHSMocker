class AddReasonColumnInAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :reason_for_visit, :text
  end
end
