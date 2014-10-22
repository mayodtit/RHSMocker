class AddDelayedJobIdToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :delayed_job_id, :integer
  end
end
