class RemoveWaitlistEntries < ActiveRecord::Migration
  def up
    drop_table :waitlist_entries
  end

  def down
    create_table "waitlist_entries", :force => true do |t|
      t.string   "email"
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.string   "token"
      t.string   "state"
      t.datetime "invited_at"
      t.datetime "claimed_at"
      t.integer  "claimer_id"
      t.integer  "creator_id"
      t.integer  "feature_group_id"
      t.integer  "revoker_id"
      t.datetime "revoked_at"
      t.integer  "lock_version",     :default => 0, :null => false
    end
  end
end
