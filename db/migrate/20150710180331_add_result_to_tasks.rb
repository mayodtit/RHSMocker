class AddResultToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :result, :boolean
  end
end
