class AddReadLaterDateToUserReadings < ActiveRecord::Migration
  def change
    add_column :user_readings, :read_later_date, :datetime
    add_column :user_readings, :read_later_count, :integer
    add_column :user_readings, :dismiss_date, :datetime
  end
end
