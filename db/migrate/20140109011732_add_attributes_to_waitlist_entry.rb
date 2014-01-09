class AddAttributesToWaitlistEntry < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :token, :string
    add_column :waitlist_entries, :state, :string
    add_column :waitlist_entries, :invited_at, :datetime
    add_column :waitlist_entries, :claimed_at, :datetime
  end
end
