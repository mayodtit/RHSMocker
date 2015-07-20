class AddTimeZoneToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :time_zone, :string
  end
end
