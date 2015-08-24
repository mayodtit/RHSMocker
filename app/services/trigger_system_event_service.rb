class TriggerSystemEventService < Struct.new(:params)
  def call
    ActiveRecord::Base.transaction do
      result = create_result!
      SystemAction.create!(system_event: system_event,
                           system_action_template: system_action_template,
                           result: result)
    end
  end

  private

  def system_event
    @system_event ||= params[:system_event]
  end

  def system_action_template
    system_event.system_event_template.system_action_template
  end

  def create_result!
    if system_action_template.system_message?
      system_event.user.master_consult.messages.create!(user: Member.robot,
                                                        text: system_action_template.message_text,
                                                        system: true,
                                                        automated: true)
    elsif system_action_template.pha_message?
      system_event.user.master_consult.messages.create!(user: system_event.user.pha,
                                                        text: system_action_template.message_text,
                                                        system: false,
                                                        automated: true)
    elsif system_action_template.service?
      system_event.user.services.create!(service_template: system_action_template.published_versioned_resource,
                                         actor: Member.robot)
    elsif system_action_template.task?
      MemberTask.create!(member: system_event.user,
                         subject: system_event.user,
                         task_template: system_action_template.unversioned_resource,
                         creator: Member.robot,
                         actor_id: Member.robot.id)
    end
  end
end
