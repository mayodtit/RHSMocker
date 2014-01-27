class AddRevokeToWaitlistEntry < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :revoker_id, :integer
    add_column :waitlist_entries, :revoked_at, :datetime
  end
end
