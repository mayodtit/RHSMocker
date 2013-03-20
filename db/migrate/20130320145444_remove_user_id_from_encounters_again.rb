class RemoveUserIdFromEncountersAgain < ActiveRecord::Migration
  def up
    remove_column :encounters, :user_id
  end

  def down
    add_column :encounters, :user_id, :integer
  end
end
