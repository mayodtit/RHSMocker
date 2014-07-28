class MessageWorkflowTemplate < CommunicationWorkflowTemplate
  belongs_to :message_template, inverse_of: :message_workflow_templates

  attr_accessible :message_template, :message_template_id

  validates :message_template, presence: true

  def add_to_member(member, relative_time)
    ScheduledMessage.create!(sender: member.pha,
                             recipient: member,
                             text: message_template.text,
                             publish_at: days_delayed.business_days.after(relative_time))
  end
end
