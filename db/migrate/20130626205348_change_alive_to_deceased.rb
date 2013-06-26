class ChangeAliveToDeceased < ActiveRecord::Migration
  def up
    add_column :users, :deceased, :boolean, :null => false, :default => false
    User.update_all("deceased = 't'", "alive = 'f'")
    remove_column :users, :alive
  end

  def down
    add_column :users, :alive, :boolean, :null => false, :default => true
    User.update_all("alive = 'f'", "deceased = 't'")
    remove_column :users, :deceased
  end
end
