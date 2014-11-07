class MessageTaskSerializer < TaskSerializer

  attributes :consult_id, :message_id

  def attributes
    super.tap do |attributes|
      if options[:shallow]
        attributes.merge!(
            consult_id: consult_id,
            message_id: message_id
        )
      end
    end
  end

  def type
    'message'
  end

  def triage_state
    case object.priority
      when MessageTask::FIRST_MESSAGE_PRIORITY
        'new member'
      when MessageTask::NTH_MESSAGE_PRIORITY
        'existing member'
      when MessageTask::NEEDS_RESPONSE_PRIORITY
        'needs response'
      when MessageTask::AFTER_HOURS_MESSAGE_PRIORITY
        'after hours'
      when MessageTask::INACTIVE_CONVERSATION_PRIORITY
        'inactive'
      when MessageTask::ACTIVE_CONVERSATION_PRIORITY
        'active'
      else
        '-'
    end
  end
end