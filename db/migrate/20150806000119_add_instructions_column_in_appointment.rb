class AddInstructionsColumnInAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :special_instructions, :text
  end
end
