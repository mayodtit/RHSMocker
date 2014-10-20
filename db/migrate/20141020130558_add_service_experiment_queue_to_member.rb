class AddServiceExperimentQueueToMember < ActiveRecord::Migration
  def change
    add_column :users, :service_experiment_queue, :boolean, null: false, default: false
  end
end
