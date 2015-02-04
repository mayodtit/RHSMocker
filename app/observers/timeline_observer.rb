class TimelineObserver < ActiveRecord::Observer
  observe :message, :task_change, :phone_call

  def after_create(observed)
    case observed.class.name
      when "TaskChange"
        return if (observed.task && observed.task.type != 'MemberTask') || (observed.event != nil && observed.event != "complete")
          observed.task.member.entries.create(resource: observed.task, resource_type: 'Task', actor_id: observed.actor_id, data: observed.entry_serializer.as_json)
      when "Message"
        if !observed.phone_call && !observed.scheduled_phone_call && !observed.phone_call_summary
          observed.consult.initiator.entries.create(resource: observed, actor: observed.user, data: observed.entry_serializer.as_json)
        end
    end
  end

  def after_save(observed)
    return if observed.class.name != "PhoneCall"

    if observed.user && observed.creator && !Entry.exists?(resource_id: observed.id)
      observed.user.entries.create(resource: observed, actor: observed.user, data: observed.entry_serializer.as_json)
    end
  end
end
