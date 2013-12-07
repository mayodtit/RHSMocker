class CreateSymptomMedicalAdviceItems < ActiveRecord::Migration
  def change
    create_table :symptom_medical_advice_items do |t|
      t.text :description
      t.integer :symptom_medical_advice_id

      t.timestamps
    end
    add_index :symptom_medical_advice_items, :symptom_medical_advice_id
  end
end
