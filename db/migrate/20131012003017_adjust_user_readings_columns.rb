class AdjustUserReadingsColumns < ActiveRecord::Migration
  def up
    remove_column :user_readings, :read_date
    remove_column :user_readings, :save_date
    remove_column :user_readings, :view_date
    remove_column :user_readings, :dismiss_date
    remove_column :user_readings, :priority
    remove_column :user_readings, :save_count
    remove_column :user_readings, :share_counter
  end

  def down
    add_column :user_readings, :read_date, :datetime
    add_column :user_readings, :save_date, :datetime
    add_column :user_readings, :view_date, :datetime
    add_column :user_readings, :dismiss_date, :datetime
    add_column :user_readings, :priority, :integer, :default => 0, :null => false
    add_column :user_readings, :save_count, :integer, :default => 0
    add_column :user_readings, :share_counter, :integer
  end
end
