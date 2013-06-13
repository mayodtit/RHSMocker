class CreateUserDiseaseTreatmentTreatmentSideEffects < ActiveRecord::Migration
  def change
    create_table :user_disease_treatment_treatment_side_effects do |t|
      t.references :user_disease_treatment, :null => false
      t.references :treatment_side_effect, :null => false
      t.timestamps
    end
  end
end
