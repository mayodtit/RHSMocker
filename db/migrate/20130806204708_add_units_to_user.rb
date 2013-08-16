class AddUnitsToUser < ActiveRecord::Migration
  def change
    add_column :users, :units, :string, :null => false, :default => 'US'
  end
end
