class Mails::AutomatedOnboardingSurveyJob < Struct.new(:user_id, :pha_id)
  def self.create(user_id, pha_id)
    Delayed::Job.enqueue(new(user_id, pha_id))
  end

  def perform
    user = Member.find(user_id)
    return if user.email_confirmed == false
    pha = Member.find(pha_id)
    RHSMailer.automated_onboarding_survey_email(user, pha).deliver
  end
end
