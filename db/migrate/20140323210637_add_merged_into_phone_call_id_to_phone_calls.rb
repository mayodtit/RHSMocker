class AddMergedIntoPhoneCallIdToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :merged_into_phone_call_id, :integer
  end
end
