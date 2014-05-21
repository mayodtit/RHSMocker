class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user
      t.references :provider
      t.datetime :scheduled_at
      t.timestamps
    end
  end
end
