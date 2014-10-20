class AddServiceExperimentToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :service_experiment, :boolean, null: false, default: false
  end
end
