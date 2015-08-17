class AddNewTimeOffsetAttributes < ActiveRecord::Migration
  def change
    add_column :time_offsets, :absolute_minutes, :integer
    add_column :time_offsets, :relative_days, :integer
    add_column :time_offsets, :relative_minutes_after_midnight, :integer
  end
end
