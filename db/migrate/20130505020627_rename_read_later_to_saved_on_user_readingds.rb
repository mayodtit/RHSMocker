class RenameReadLaterToSavedOnUserReadingds < ActiveRecord::Migration
  def up
  	rename_column :user_readings, :read_later_date, :save_date
  	rename_column :user_readings, :read_later_count, :save_count
  end

  def down
  	rename_column :user_readings, :save_date, :read_later_date
  	rename_column :user_readings, :save_count, :read_later_count
  end
end
