class AddTwilioConferenceNameToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :twilio_conference_name, :string
  end
end
