class AddTwilioSidsToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :destination_twilio_sid, :string
    add_index :phone_calls, :destination_twilio_sid

    add_column :phone_calls, :origin_twilio_sid, :string
    add_index :phone_calls, :origin_twilio_sid
  end
end
