class CreateUserDiseaseTreatmentSideEffects < ActiveRecord::Migration
  def change
    create_table :user_disease_treatment_side_effects do |t|
      t.references :user_disease_treatment
      t.references :side_effect
      t.timestamps
    end
  end
end
