class AddOnboardingFieldsToScheduledPhoneCalls < ActiveRecord::Migration
  def up
    add_column :scheduled_phone_calls, :assignor_id, :integer
    add_column :scheduled_phone_calls, :assigned_at, :datetime
    add_column :scheduled_phone_calls, :booker_id, :integer
    add_column :scheduled_phone_calls, :booked_at, :datetime
    add_column :scheduled_phone_calls, :starter_id, :integer
    add_column :scheduled_phone_calls, :started_at, :datetime
    add_column :scheduled_phone_calls, :canceler_id, :integer
    add_column :scheduled_phone_calls, :canceled_at, :datetime
    add_column :scheduled_phone_calls, :ender_id, :integer
    add_column :scheduled_phone_calls, :ended_at, :datetime
    add_column :scheduled_phone_calls, :scheduled_duration_s, :integer, null: false, default: ScheduledPhoneCall::DEFAULT_SCHEDULED_DURATION.to_i
  end
end
