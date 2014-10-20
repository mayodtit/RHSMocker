class SystemMessageWorkflowTemplate < CommunicationWorkflowTemplate
  belongs_to :message_template, inverse_of: :system_message_workflow_templates

  attr_accessible :message_template, :message_template_id

  validates :message_template, presence: true

  def add_to_member(member, relative_time)
    create_attributes = reference_attributes(member).merge!({
      recipient: member,
      text: message_template.text,
      publish_at: calculated_publish_at(member, relative_time)
    })
    ScheduledSystemMessage.create!(create_attributes)
  end
end
