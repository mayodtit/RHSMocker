class ChangeCompletedDateToReadDateInUserReading < ActiveRecord::Migration
  def up
  	rename_column :user_readings, :completed_date, :read_date
  end

  def down
  	rename_column :user_readings, :read_date, :completed_date
  end
end
