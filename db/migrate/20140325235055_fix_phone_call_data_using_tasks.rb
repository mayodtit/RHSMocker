class FixPhoneCallDataUsingTasks < ActiveRecord::Migration
  def up
    # PhoneCallTask.order(:id).each do |phone_call_task|
    PhoneCallTask.all.each do |phone_call_task|
      puts "Processing PhoneCallTask #{phone_call_task.id}"
      phone_call = phone_call_task.phone_call

      if phone_call.ender == Member.robot
        puts "  Setting PhoneCall #{phone_call.id} owner to #{phone_call_task.owner_id} and completed_at to #{phone_call_task.completed_at}"
        phone_call.ender = phone_call_task.owner
        phone_call.ended_at = phone_call_task.completed_at
        phone_call.save!
      else
        puts "  PhoneCall ender isn't the Member robot"
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover transferred phone calls"
  end
end