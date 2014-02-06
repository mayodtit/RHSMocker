class AddLockVersionToWaitlistEntries < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :lock_version, :integer, null: false, default: 0
  end
end
