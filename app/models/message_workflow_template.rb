class MessageWorkflowTemplate < CommunicationWorkflowTemplate
  belongs_to :message_template, inverse_of: :message_workflow_templates

  attr_accessible :message_template, :message_template_id, :system_message

  validates :message_template, presence: true
  validates :system_message, inclusion: {in: [true, false]}

  before_validation :set_defaults

  def add_to_member(member, relative_time)
    create_attributes = reference_attributes(member).merge!({
      sender: member.pha,
      recipient: member,
      text: message_template.text,
      publish_at: calculated_publish_at(relative_time),
      system_message: system_message
    })
    ScheduledMessage.create!(create_attributes)
  end

  private

  def set_defaults
    self.system_message = false if system_message.nil?
    true
  end
end
