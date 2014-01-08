class CreateWaitlistEntries < ActiveRecord::Migration
  def change
    create_table :waitlist_entries do |t|
      t.string :email
      t.timestamps
    end
  end
end
