class RemoveStartedAtFromScheduledPhoneCalls < ActiveRecord::Migration
  def up
    remove_column :scheduled_phone_calls, :started_at
  end

  def down
    add_column :scheduled_phone_calls, :started_at, :timestamp
  end
end
