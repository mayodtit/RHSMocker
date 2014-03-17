class ConvertTransferredStateOnPhoneCalls < ActiveRecord::Migration
  def up
    PhoneCall.where(state: :transferred).update_all(["state = 'ended', ender_id = transferrer_id, ended_at = transferred_at"])

    # Clean up any invalid records
    PhoneCall.where(state: :ended).find_each do |phone_call|
      phone_call.ender = Member.robot
      phone_call.ended_at = Time.now
      phone_call.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover transferred phone calls"
  end
end
