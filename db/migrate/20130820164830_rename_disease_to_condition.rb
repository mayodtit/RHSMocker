class RenameDiseaseToCondition < ActiveRecord::Migration
  def up
    rename_column :user_conditions, :disease_id, :condition_id
    rename_table :diseases, :conditions
  end

  def down
    rename_table :conditions, :diseases
    rename_column :user_conditions, :condition_id, :disease_id
  end
end
