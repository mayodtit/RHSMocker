class ScheduledTemplateEmailSerializer < ScheduledCommunicationSerializer
  attributes :text

  def text
    object.template
  end

  def type
    'template'
  end
end
