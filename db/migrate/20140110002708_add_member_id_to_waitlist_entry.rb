class AddMemberIdToWaitlistEntry < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :member_id, :integer
  end
end
