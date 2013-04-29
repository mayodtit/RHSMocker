class CreateBloodPressures < ActiveRecord::Migration
  def change
    create_table :blood_pressures do |t|
      t.integer :systolic
      t.integer :diastolic
      t.integer :pulse
      t.references :collection_type
      t.references :user

      t.timestamps
    end
    add_index :blood_pressures, :collection_type_id
    add_index :blood_pressures, :user_id
  end
end
