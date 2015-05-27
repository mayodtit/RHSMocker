class ScheduledMessageSerializer < ScheduledCommunicationSerializer
  attributes :message_id, :text, :content_id, :content_title, :service_id, :service_title

  def content_title
    object.content.try(:title)
  end

  def service_title
    object.service.try(:title)
  end

  def type
    'message'
  end
end
