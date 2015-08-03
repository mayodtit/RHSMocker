class CreateAppointmentTemplates < ActiveRecord::Migration
  def change
    create_table :appointment_templates do |t|
      t.datetime :scheduled_at

      t.timestamps
    end
  end
end
