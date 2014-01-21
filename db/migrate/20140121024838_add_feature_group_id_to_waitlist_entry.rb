class AddFeatureGroupIdToWaitlistEntry < ActiveRecord::Migration
  def change
    add_column :waitlist_entries, :feature_group_id, :integer
  end
end
