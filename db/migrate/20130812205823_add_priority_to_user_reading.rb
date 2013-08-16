class AddPriorityToUserReading < ActiveRecord::Migration
  def change
    add_column :user_readings, :priority, :integer, :null => false, :default => 0
  end
end
