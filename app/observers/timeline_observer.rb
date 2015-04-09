class TimelineObserver < ActiveRecord::Observer
  observe :service_change, :phone_call, :message

  def after_create(observed)
    case observed.class.name
      when 'ServiceChange'
        return if (observed.event != nil && observed.event != "complete")
        observed.service.member.entries.create(resource: observed.service, resource_type: 'Service', actor_id: observed.actor_id, data: observed.entry_serializer.as_json)
      when 'Message'
        return if observed.phone_call || observed.scheduled_phone_call || observed.phone_call_summary
        observed.consult.initiator.entries.create(resource: observed, actor_id: observed.user_id, data: observed.entry_serializer.as_json)
    end
  end

  def after_save(observed)
    return unless observed.is_a? PhoneCall

    if observed.user && observed.creator && !Entry.exists?(resource_id: observed.id)
      observed.user.entries.create(resource: observed, actor: observed.user, data: observed.entry_serializer.as_json)
    end
  end
end
