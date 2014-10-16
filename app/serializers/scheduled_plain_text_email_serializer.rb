class ScheduledPlainTextEmailSerializer < ScheduledCommunicationSerializer
  attributes :text

  def type
    'plain'
  end
end
