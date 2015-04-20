class DropCityAndStateFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :city
    state_column_exists = false ## TODO SQL figure it out!
    if state_column_exists
      ## TODO SQL ALTER TABLE to drop it
    end
  end

  def down
    add_column :users, :city, :string
    add_column :users, :state, :string
  end
end
