class MessageWorkflowTemplate < CommunicationWorkflowTemplate
  belongs_to :message_template, inverse_of: :message_workflow_templates

  attr_accessible :message_template, :message_template_id

  validates :message_template, presence: true

  def add_to_member(member, relative_time)
    create_attributes = reference_attributes(member).merge!({
      sender: member.pha,
      recipient: member,
      text: message_template.text,
      publish_at: calculated_publish_at(member, relative_time)
    })
    # TODO - workaround for timing hack, sometimes two messages will be scheduled for the same time,
    #        if this happens, roll one of them forward a few hours.
    if member.reload.inbound_scheduled_communications.where(publish_at: create_attributes[:publish_at]).any?
      create_attributes[:publish_at] = create_attributes[:publish_at] + 3.hours
    end
    ScheduledMessage.create!(create_attributes)
  end
end
