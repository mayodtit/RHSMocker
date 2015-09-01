class AddDelayedJobToSystemEvent < ActiveRecord::Migration
  def change
    add_column :system_events, :delayed_job_id, :integer
  end
end
