class AddAliveToUser < ActiveRecord::Migration
  def change
    add_column :users, :alive, :boolean, :default => true
    add_column :users, :date_of_death, :date
  end
end
