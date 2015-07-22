class CreateAppointmentChangesTable < ActiveRecord::Migration
  def change
    create_table :appointment_changes do |t|
      t.integer :appointment_id, null: false
      t.integer :actor_id, null: false
      t.string :event
      t.string :from
      t.string :to
      t.text :data
      t.string :reason

      t.timestamps
    end
  end
end
