class RemoveUserIdFromEncounters < ActiveRecord::Migration
  def up
    remove_column :encounters, :user
  end

  def down
    add_column :encounters, :user, :references
  end
end
