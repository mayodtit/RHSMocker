class ScheduledSystemMessage < ScheduledCommunication
  belongs_to :message

  attr_accessible :message, :message_id, :text

  validates :text, presence: true
  validates :message, presence: true, if: ->(s){s.message_id}

  def formatted_text
    MessageTemplate.formatted_text(nil, recipient, text, variables)
  end

  def can_deliver?
    MessageTemplate.can_format_text?(nil, recipient, text, variables)
  end

  def deliver_message
    self.message = build_message(user: Member.robot,
                                 consult: recipient.master_consult,
                                 text: formatted_text,
                                 system: true)
  end

  private

  state_machine do
    before_transition any => :delivered do |scheduled_message, transition|
      scheduled_message.deliver_message
    end
  end
end
