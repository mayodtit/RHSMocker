class RenameContentsSymptomFactorsToContentsSymptomsFactors < ActiveRecord::Migration
  def change
    rename_table :contents_symptom_factors, :contents_symptoms_factors
  end
end
