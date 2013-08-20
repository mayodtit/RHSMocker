class RenameUserDiseaseToUserCondition < ActiveRecord::Migration
  def up
    remove_index :user_diseases, :disease_id
    remove_index :user_diseases, :user_id
    rename_column :user_disease_user_treatments, :user_disease_id, :user_condition_id
    rename_table :user_disease_user_treatments, :user_condition_user_treatments
    rename_table :user_diseases, :user_conditions
  end

  def down
    rename_table :user_condition_user_treatments, :user_disease_user_treatments
    rename_table :user_conditions, :user_diseases
    rename_column :user_disease_user_treatments, :user_condition_id, :user_disease_id
    add_index :user_diseases, :disease_id
    add_index :user_diseases, :user_id
  end
end
