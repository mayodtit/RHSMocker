class ConvertTransferredStateOnPhoneCalls < ActiveRecord::Migration
  def up
    PhoneCall.where('state = ?', :transferred).find_each do |phone_call|
      phone_call.state = :ended
      phone_call.ender = phone_call.transferrer || Member.robot
      phone_call.ended_at = phone_call.transferred_at || Time.now
      phone_call.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover transferred phone calls"
  end
end
