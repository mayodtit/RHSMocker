class CreateUserDiseaseTreatments < ActiveRecord::Migration
  def change
    create_table :user_disease_treatments do |t|
      t.boolean :prescribed_by_doctor
      t.date :start_date
      t.date :end_date
      t.integer :time_duration
      t.string :time_duration_unit
      t.integer :amount
      t.string :amount_unit
      t.boolean :side_effect
      t.boolean :successful
      t.references :user_disease
      t.references :treatment
      t.references :user
      t.integer :doctor_user_id

      t.timestamps
    end
    add_index :user_disease_treatments, :user_disease_id
    add_index :user_disease_treatments, :treatment_id
    add_index :user_disease_treatments, :user_id
  end
end
