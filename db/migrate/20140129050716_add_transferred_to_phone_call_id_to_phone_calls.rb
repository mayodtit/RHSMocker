class AddTransferredToPhoneCallIdToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :transferred_to_phone_call_id, :integer
  end
end