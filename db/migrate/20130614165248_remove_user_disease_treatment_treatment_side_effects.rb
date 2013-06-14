class RemoveUserDiseaseTreatmentTreatmentSideEffects < ActiveRecord::Migration
  def up
    drop_table :user_disease_treatment_treatment_side_effects
  end

  def down
    create_table :user_disease_treatment_treatment_side_effects do |t|
      t.references :user_disease_treatment, :null => false
      t.references :treatment_side_effect, :null => false
      t.timestamps
    end
  end
end
