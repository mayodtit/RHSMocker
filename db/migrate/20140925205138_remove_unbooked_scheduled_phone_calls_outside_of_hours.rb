class RemoveUnbookedScheduledPhoneCallsOutsideOfHours < ActiveRecord::Migration
  def up
    num_records_destroyed = 0
    ScheduledPhoneCall.where('state IN (?, ?)', :unassigned, :assigned).find_each do |s|
      unless s.valid?
        s.destroy
        num_records_destroyed += 1
      end
    end
    pp "Destroyed #{num_records_destroyed} ScheduledPhoneCalls"
  end

  def down
  end
end
