class RenameEncounterToConsult < ActiveRecord::Migration
  def up
    rename_column :messages, :encounter_id, :consult_id
    remove_index :encounter_users, name: :index_encounters_users_on_encounter_id
    remove_index :encounter_users, name: :index_encounters_users_on_user_id
    rename_column :encounter_users, :encounter_id, :consult_id
    rename_table :encounter_users, :consult_users
    rename_table :encounters, :consults
  end

  def down
    rename_table :consult_users, :encounter_users
    rename_table :consults, :encounters
    rename_column :messages, :consult_id, :encounter_id
    rename_column :encounter_users, :consult_id, :encounter_id
    add_index :encounter_users, :encounter_id, name: :index_encounters_users_on_encounter_id
    add_index :encounter_users, :user_id, name: :index_encounters_users_on_user_id
  end
end
