class AddDisabledAtToScheduledPhoneCalls < ActiveRecord::Migration
  def change
    add_column :scheduled_phone_calls, :disabled_at, :timestamp
  end
end
