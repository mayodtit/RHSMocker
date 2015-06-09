class CreateFeatureFlagChanges < ActiveRecord::Migration
  def change
    create_table :feature_flag_changes do |t|
      t.integer :feature_flag_id
      t.integer :actor_id
      t.text :data

      t.timestamps
    end
      add_index :feature_flag_changes, :feature_flag_id
  end
end
