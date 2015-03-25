class DeleteViewTaskTasks < ActiveRecord::Migration
  def up
    Task.where(type: 'ViewTaskTask').delete_all
  end

  def down
  end
end
