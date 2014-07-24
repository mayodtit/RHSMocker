class ScheduledTemplateEmail < ScheduledCommunication
  belongs_to :recipient, class_name: 'Member'

  attr_accessible :recipient, :recipient_id, :template

  validates :recipient, :template, presence: true

  def can_deliver?
    case template.to_sym
    when :automated_onboarding_survey_email
      true
    else
      false
    end
  end

  def deliver_email
    case template.to_sym
    when :automated_onboarding_survey_email
      Mails::AutomatedOnboardingSurveyJob.create(recipient_id, sender_id)
    else
      raise 'Unknown email template'
    end
  end

  private

  state_machine do
    before_transition any => :delivered do |scheduled_template_email, transition|
      scheduled_template_email.deliver_email
    end
  end
end
