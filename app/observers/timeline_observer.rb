class TimelineObserver < ActiveRecord::Observer
  observe :message, :member_task

  def after_create(observed)

    if observed.respond_to?(:member) && !observed.member.nil?
      member = observed.member
    elsif observed.respond_to?(:user) && !observed.user.nil?
      member = observed.user.member
    else
      return
    end

    case observed.class.name
      when "MemberTask"
        member.entries.create(resource: observed, resource_type: "Task", actor_id: observed.actor_id, data: observed.entry_serializer.as_json)
      when "Message"
        if !observed.phone_call || !observed.scheduled_phone_call || !observed.phone_call_summary
          observed.consult.initiator.entries.create(resource: observed, actor: member, data: observed.entry_serializer.as_json)
        end
    end
  end
end
