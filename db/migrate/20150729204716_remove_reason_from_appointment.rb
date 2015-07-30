class RemoveReasonFromAppointment < ActiveRecord::Migration
  def up
    remove_column :appointments, :reason
  end

  def down
    add_column :appointments, :reason, :string
  end
end
