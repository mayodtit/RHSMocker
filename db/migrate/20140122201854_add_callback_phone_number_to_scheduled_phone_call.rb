class AddCallbackPhoneNumberToScheduledPhoneCall < ActiveRecord::Migration
  def change
    add_column :scheduled_phone_calls, :callback_phone_number, :string
  end
end
