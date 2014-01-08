class AddGenderToSymptomMedicalAdviceItem < ActiveRecord::Migration
  def change
    add_column :symptom_medical_advice_items, :gender, :string
  end
end
