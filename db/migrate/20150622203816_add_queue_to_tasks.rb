class AddQueueToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :queue, :string
  end
end
