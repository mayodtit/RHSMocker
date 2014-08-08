class ScheduledSystemMessageSerializer < ScheduledCommunicationSerializer
  attributes :message_id, :text

  def state_events
    []
  end
end
