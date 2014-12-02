class RemoveServiceExperimentFromTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :service_experiment
  end

  def down
    add_column :tasks, :service_experiment, :boolean
  end
end
