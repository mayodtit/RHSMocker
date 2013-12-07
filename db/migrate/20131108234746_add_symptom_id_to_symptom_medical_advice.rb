class AddSymptomIdToSymptomMedicalAdvice < ActiveRecord::Migration
  def change
    add_column :symptom_medical_advices, :symptom_id, :integer
    add_index :symptom_medical_advices, :symptom_id
  end
end
