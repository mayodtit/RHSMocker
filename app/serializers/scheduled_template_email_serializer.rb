class ScheduledTemplateEmailSerializer < ScheduledCommunicationSerializer
  attributes :text

  def text
    object.template
  end
end
