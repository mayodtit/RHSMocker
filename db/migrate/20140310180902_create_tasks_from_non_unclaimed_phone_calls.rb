class CreateTasksFromNonUnclaimedPhoneCalls < ActiveRecord::Migration
  def up
    phone_calls = PhoneCall.where('state != ?', 'unclaimed')
    phone_calls.find_each do |phone_call|
      if phone_call.phone_call_tasks.empty?
        if phone_call.state == 'ended'
          PhoneCallTask.create!(
            title: phone_call.consult ? phone_call.consult.title : 'Unknown',
            phone_call: phone_call,
            creator: Member.robot,
            due_at: phone_call.created_at,
            state: 'completed',
            owner: phone_call.claimer,
            completed_at: phone_call.ended_at,
            claimed_at: phone_call.claimed_at
          )
        elsif phone_call.state == 'claimed'
          # Mark the task as started because the old system let you claim multiple
          # phone calls at once.
          PhoneCallTask.create!(
            title: phone_call.consult ? phone_call.consult.title : 'Unknown',
            phone_call: phone_call,
            creator: Member.robot,
            due_at: phone_call.created_at,
            state: 'started',
            owner: phone_call.claimer,
            started_at: phone_call.claimed_at
          )
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove migration generated tasks."
  end
end
