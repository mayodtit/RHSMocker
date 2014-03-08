class CreateTasksForPhoneCallsAndMessages < ActiveRecord::Migration
  def up
    unread_messages = Message.where(phone_call_id: nil, scheduled_phone_call_id: nil).where('unread_by_cp is true').group('consult_id')
    unread_messages.find_each do |message|
      Task.create_unique_open_message_for_consult! message.consult, message
    end

    empty_consults = Consult.joins('LEFT JOIN messages ON messages.consult_id = consults.id').select('consults.*').group('consults.id').having('COUNT(messages.consult_id) = 0')
    empty_consults.find_each do |consult|
      Task.create_unique_open_message_for_consult! consult
    end

    unclaimed_phone_calls = PhoneCall.where(state: :unclaimed)
    unclaimed_phone_calls.find_each do |phone_call|
      if phone_call.tasks.empty?
        Task.create!(
          title: phone_call.consult ? phone_call.consult.title : 'Unknown',
          consult: phone_call.consult,
          phone_call: phone_call,
          creator: Member.robot,
          due_at: phone_call.created_at
        )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove migration generated tasks."
  end
end
