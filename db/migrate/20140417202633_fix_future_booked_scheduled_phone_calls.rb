class FixFutureBookedScheduledPhoneCalls < ActiveRecord::Migration
  def up
    ScheduledPhoneCall.where(['state = ? AND scheduled_at > ? AND user_id IS NOT NULL', :assigned, Time.now]).each do |s|
      next if s.user_id == 1844 # He's booked two

      if s.callback_phone_number.nil?
        puts "INVALID SCHEDULED_PHONE_CALL: #{s.id} - NO CALLBACK PHONE NUMBER"
      else
        s.update_attributes! state_event: :book
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Can\'t revert state changes of ScheduledPhoneCalls'
  end
end
