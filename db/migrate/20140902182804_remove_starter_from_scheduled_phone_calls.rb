class RemoveStarterFromScheduledPhoneCalls < ActiveRecord::Migration
  def up
    remove_column :scheduled_phone_calls, :starter_id
  end

  def down
    add_column :scheduled_phone_calls, :starter_id, :integer
  end
end
