class AddViewDateToUserReading < ActiveRecord::Migration
  def change
    add_column :user_readings, :view_date, :datetime
  end
end
