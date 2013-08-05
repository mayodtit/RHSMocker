class RenameUserLocation < ActiveRecord::Migration
  def up
    rename_table :user_locations, :locations
    rename_column :messages, :user_location_id, :location_id
  end

  def down
    rename_table :locations, :user_locations
    rename_column :messages, :location_id, :user_location_id
  end
end
