class AddClaimerAndCreatorToWaitlistEntry < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :claimer_id, :integer
    add_column :waitlist_entries, :creator_id, :integer
  end
end
