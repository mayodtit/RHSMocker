class Mails::AutomatedOnboardingTestimonialsJob < Struct.new(:user_id, :pha_id)
  def self.create(user_id, pha_id)
    Delayed::Job.enqueue(new(user_id, pha_id))
  end

  def perform
    user = Member.find(user_id)
    pha = Member.find(pha_id)
    RHSMailer.automated_onboarding_testimonials_email(user, pha).deliver
  end
end
