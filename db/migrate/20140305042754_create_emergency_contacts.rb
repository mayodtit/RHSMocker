class CreateEmergencyContacts < ActiveRecord::Migration
  def change
    create_table :emergency_contacts do |t|
      t.references :user
      t.references :designee
      t.string :name
      t.string :phone_number
      t.timestamps
    end
  end
end
