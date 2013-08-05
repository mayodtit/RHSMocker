class RenameEncountersUser < ActiveRecord::Migration
  def up
    rename_table :encounters_users, :encounter_users
  end

  def down
    rename_table :encounter_users, :encounters_users
  end
end
