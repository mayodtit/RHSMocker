class AddTimeZoneOffsetToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :time_zone_offset, :integer 
  end
end
