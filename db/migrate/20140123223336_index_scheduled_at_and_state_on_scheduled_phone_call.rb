class IndexScheduledAtAndStateOnScheduledPhoneCall < ActiveRecord::Migration
  def change
    add_index :scheduled_phone_calls, :scheduled_at
    add_index :scheduled_phone_calls, :state
    add_index :scheduled_phone_calls, [:state, :scheduled_at]
  end
end
