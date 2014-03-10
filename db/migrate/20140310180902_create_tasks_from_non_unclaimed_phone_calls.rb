class CreateTasksFromNonUnclaimedPhoneCalls < ActiveRecord::Migration
  def up
    phone_calls = PhoneCall.where('state != ?', 'unclaimed')
    phone_calls.find_each do |phone_call|
      if phone_call.phone_call_tasks.empty?
        if phone_call.state == 'ended'
          t = PhoneCallTask.new(
            title: phone_call.consult ? phone_call.consult.title : 'Unknown',
            phone_call: phone_call,
            creator: Member.robot,
            due_at: phone_call.created_at,
            owner: phone_call.claimer
          )
          t.state = 'completed'
          t.completed_at = phone_call.ended_at
          t.claimed_at = phone_call.claimed_at
          t.save!
        elsif phone_call.state == 'claimed'
          # Mark the task as started because the old system let you claim multiple
          # phone calls at once.
          t = PhoneCallTask.new(
            title: phone_call.consult ? phone_call.consult.title : 'Unknown',
            phone_call: phone_call,
            creator: Member.robot,
            due_at: phone_call.created_at,
            owner: phone_call.claimer
          )
          t.state = 'started'
          t.started_at = phone_call.started_at
          t.save!
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove migration generated tasks."
  end
end
