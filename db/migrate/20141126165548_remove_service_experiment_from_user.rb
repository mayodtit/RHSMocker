class RemoveServiceExperimentFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :service_experiment
    remove_column :users, :service_experiment_queue
  end

  def down
    add_column :users, :service_experiment_queue, :boolean
    add_column :users, :service_experiment, :boolean
  end
end
