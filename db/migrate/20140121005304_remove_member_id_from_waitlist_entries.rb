class RemoveMemberIdFromWaitlistEntries < ActiveRecord::Migration
  def up
    remove_column :waitlist_entries, :member_id
  end

  def down
    add_column :waitlist_entries, :member_id, :integer
  end
end
