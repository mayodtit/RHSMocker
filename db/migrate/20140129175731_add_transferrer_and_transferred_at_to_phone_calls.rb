class AddTransferrerAndTransferredAtToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :transferrer_id, :integer
    add_column :phone_calls, :transferred_at, :datetime
  end
end
