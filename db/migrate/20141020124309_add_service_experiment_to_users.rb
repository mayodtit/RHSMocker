class AddServiceExperimentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :service_experiment, :boolean, null: false, default: false
  end
end
