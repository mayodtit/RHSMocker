class TemplateEmailWorkflowTemplate < CommunicationWorkflowTemplate
  attr_accessible :template

  validates :template, presence: true

  def add_to_member(member, relative_time)
    create_attributes = reference_attributes(member).merge!({
      sender: member.pha,
      recipient: member,
      template: template,
      publish_at: calculated_publish_at(member, relative_time)
    })
    ScheduledTemplateEmail.create!(create_attributes)
  end
end
