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
    case system_action_template.type
    when :system_message
      system_event.user.master_consult.messages.create!(user: Member.robot,
                                                        text: system_action_template.message_text,
                                                        system: true,
                                                        automated: true)
    when :pha_message
      system_event.user.master_consult.messages.create!(user: system_event.user.pha,
                                                        text: system_action_template.message_text,
                                                        system: false,
                                                        automated: true)
    end
  end
end
