class ReaddFieldsToUserReadings < ActiveRecord::Migration
  def up
    add_column :user_readings, :view_count, :integer, :null => false, :default => 0
    add_column :user_readings, :save_count, :integer, :null => false, :default => 0
    add_column :user_readings, :dismiss_count, :integer, :null => false, :default => 0
    add_column :user_readings, :share_count, :integer, :null => false, :default => 0
  end

  def down
    remove_column :user_readings, :view_count
    remove_column :user_readings, :save_count
    remove_column :user_readings, :dismiss_count
    remove_column :user_readings, :share_count
  end
end
