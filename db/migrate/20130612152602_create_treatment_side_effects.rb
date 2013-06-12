class CreateTreatmentSideEffects < ActiveRecord::Migration
  def change
    create_table :treatment_side_effects do |t|
      t.references :treatment
      t.references :side_effect
      t.timestamps
    end
  end
end
