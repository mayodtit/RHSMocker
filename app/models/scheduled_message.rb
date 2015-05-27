class ScheduledMessage < ScheduledCommunication
  belongs_to :message
  belongs_to :content
  belongs_to :service

  attr_accessible :message, :message_id, :text, :content, :content_id, :service, :service_id

  validates :sender, :text, presence: true
  validates :message, presence: true, if: ->(s){s.message_id}
  validates :content, presence: true, if: ->(s){s.content_id}
  validates :service, presence: true, if: ->(s){s.service_id}

  def formatted_text
    MessageTemplate.formatted_text(sender, recipient, text, variables)
  end

  def can_deliver?
    MessageTemplate.can_format_text?(sender, recipient, text, variables)
  end

  def deliver_message
    self.message = build_message(user: sender,
                                 consult: recipient.master_consult,
                                 text: formatted_text,
                                 content: content,
                                 service: service,
                                 automated: true)
  end

  private

  state_machine do
    before_transition any => :delivered do |scheduled_message, transition|
      scheduled_message.deliver_message
    end
  end
end
