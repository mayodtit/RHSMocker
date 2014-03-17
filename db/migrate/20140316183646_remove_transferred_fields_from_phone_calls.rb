class RemoveTransferredFieldsFromPhoneCalls < ActiveRecord::Migration
  def up
    remove_column :phone_calls, :transferrer_id
    remove_column :phone_calls, :transferred_at
  end

  def down
    add_column :phone_calls, :transferred_at, :timestamp
    add_column :phone_calls, :transferrer_id, :integer
  end
end
