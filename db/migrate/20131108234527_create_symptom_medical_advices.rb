class CreateSymptomMedicalAdvices < ActiveRecord::Migration
  def change
    create_table :symptom_medical_advices do |t|
      t.text :description

      t.timestamps
    end
  end
end
