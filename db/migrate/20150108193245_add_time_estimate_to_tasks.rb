class AddTimeEstimateToTasks < ActiveRecord::Migration
  def change
    add_column :task, :time_estimate, :integer
    add_column :task_templates, :time_estimate, :integer
  end
end
