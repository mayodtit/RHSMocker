class ScheduledPlainTextEmail < ScheduledCommunication
  attr_accessible :subject, :text

  validates :sender, :subject, :text, presence: true

  def formatted_text
    MessageTemplate.formatted_text(sender, recipient, text, variables)
  end

  def can_deliver?
    MessageTemplate.can_format_text?(sender, recipient, text, variables)
  end

  def deliver_email
    Mails::PlainTextJob.create(recipient_id, sender_id, subject, formatted_text)
  end

  private

  state_machine do
    before_transition any => :delivered do |scheduled_email, transition|
      scheduled_email.deliver_email
    end
  end
end
