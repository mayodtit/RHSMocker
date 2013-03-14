class CreateEncountersUsers < ActiveRecord::Migration
  def change
    create_table :encounters_users do |t|
      t.string :role
      t.references :encounter
      t.references :user

      t.timestamps
    end
    add_index :encounters_users, :encounter_id
    add_index :encounters_users, :user_id
  end
end
