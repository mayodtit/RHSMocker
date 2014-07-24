class AddReminderScheduledMessageToScheduledPhoneCall < ActiveRecord::Migration
  def change
    add_column :scheduled_phone_calls, :reminder_scheduled_message_id, :integer
  end
end
