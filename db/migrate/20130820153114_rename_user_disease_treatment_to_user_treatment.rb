class RenameUserDiseaseTreatmentToUserTreatment < ActiveRecord::Migration
  def up
    remove_index :user_disease_treatments, :treatment_id
    remove_index :user_disease_treatments, :user_id
    rename_column :user_disease_treatment_side_effects, :user_disease_treatment_id, :user_treatment_id
    rename_column :user_disease_user_treatments, :user_disease_treatment_id, :user_treatment_id
    rename_table :user_disease_treatment_side_effects, :user_treatment_side_effects
    rename_table :user_disease_treatments, :user_treatments
  end

  def down
    rename_table :user_treatment_side_effects, :user_disease_treatment_side_effects
    rename_table :user_treatments, :user_disease_treatments
    rename_column :user_disease_treatment_side_effects, :user_treatment_id, :user_disease_treatment_id
    rename_column :user_disease_user_treatments, :user_treatment_id, :user_disease_treatment_id
    add_index :user_disease_treatments, :treatment_id
    add_index :user_disease_treatments, :user_id
  end
end
