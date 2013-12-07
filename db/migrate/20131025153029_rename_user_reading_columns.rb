class RenameUserReadingColumns < ActiveRecord::Migration
  def up
    rename_column :user_readings, :view_count, :viewed_count
    rename_column :user_readings, :save_count, :saved_count
    rename_column :user_readings, :dismiss_count, :dismissed_count
    rename_column :user_readings, :share_count, :shared_count
  end

  def down
    rename_column :user_readings, :viewed_count, :view_count
    rename_column :user_readings, :saved_count, :save_count
    rename_column :user_readings, :dismissed_count, :dismiss_count
    rename_column :user_readings, :shared_count, :share_count
  end
end
