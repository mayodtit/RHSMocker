class AddShareCounterToUserReading < ActiveRecord::Migration
  def change
    add_column :user_readings, :share_counter, :integer
  end
end
