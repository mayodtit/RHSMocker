class AddMissedAtToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :missed_at, :datetime
  end
end
