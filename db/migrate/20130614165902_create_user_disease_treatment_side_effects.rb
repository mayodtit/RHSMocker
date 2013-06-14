class CreateUserDiseaseTreatmentSideEffects < ActiveRecord::Migration
  def change
    create_table :user_disease_treatment_side_effects do |t|

      t.timestamps
    end
  end
end
