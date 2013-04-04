class RenameSymptomFactorsToSymptomsFactorsOnContentsSymptomsFactors < ActiveRecord::Migration
  def change
    rename_column :contents_symptoms_factors, :symptom_factor_id, :symptoms_factor_id
    rename_index :contents_symptoms_factors, :symptom_factor_id, :symptoms_factor_id
  end
end
