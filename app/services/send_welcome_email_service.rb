class SendWelcomeEmailService
  def initialize(user)
    @user = user
  end

  def call
    return if @user.onboarding_group.try(:skip_emails?)
    if @user.onboarding_group.try(:welcome_email_template)
      send_templated_welcome_email
    elsif @user.trial?
      send_trial_welcome_email
    elsif @user.free?
      send_free_welcome_email
    elsif @user.premium?
      send_premium_welcome_email
    end
  end

  private

  def send_trial_welcome_email
    if @user.onboarding_group.try(:mayo_pilot?) && @user.onboarding_group.try(:provider)
      Mails::MayoPilotMeetYourPhaJob.create(@user.id, @user.onboarding_group.provider.id)
    else
      Mails::MeetYourPhaJob.create(@user.id)
    end
  end

  def send_free_welcome_email
    Mails::WelcomeToBetterFreeTrialJob.create(@user.id)
  end

  def send_premium_welcome_email
    Mails::MeetYourPhaMonthTrialJob.create(@user.id)
  end

  def send_templated_welcome_email
    Mails::CustomWelcomeEmailJob.create(@user.id, @user.onboarding_group.try(:welcome_email_template))
  end
end
