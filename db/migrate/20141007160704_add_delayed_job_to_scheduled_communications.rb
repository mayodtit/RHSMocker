class AddDelayedJobToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :delayed_job_id, :integer
  end
end
