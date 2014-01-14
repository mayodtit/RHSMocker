class ChangeDefaultStateForScheduledPhoneCalls < ActiveRecord::Migration
  def up
    change_column_default :scheduled_phone_calls, :state, 'unassigned'
  end

  def down
    change_column_default :scheduled_phone_calls, :state, 'unclaimed'
  end
end
