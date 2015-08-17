class RemoveTimeOffsetTimeColumns < ActiveRecord::Migration
  def up
    remove_column :time_offsets, :fixed_time
    remove_column :time_offsets, :relative_time
    remove_column :time_offsets, :num_days
  end

  def down
    add_column :time_offsets, :fixed_time, :time
    add_column :time_offsets, :relative_time, :time
    add_column :time_offsets, :num_days, :integer
  end
end
