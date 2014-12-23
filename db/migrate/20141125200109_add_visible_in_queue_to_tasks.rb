class AddVisibleInQueueToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :visible_in_queue, :boolean, :default => true, :null => false
  end
end
