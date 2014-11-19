class SendWelcomeEmailService
  def initialize(user)
    @user = user
  end

  def call
    if @user.trial?
      send_trial_welcome_email
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

  def send_premium_welcome_email
    Mails::MeetYourPhaMonthTrialJob.create(@user.id)
  end
end
