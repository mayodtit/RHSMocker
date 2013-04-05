class AddTypeFieldToSymptoms < ActiveRecord::Migration
  def change
    add_column :symptoms, :patient_type, :string
  end
end
