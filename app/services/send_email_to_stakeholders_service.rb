class SendEmailToStakeholdersService
  def initialize(user)
    @user = user
    @onboarding_group = @user.onboarding_group
  end

  def call
    if @onboarding_group.try(:skip_automated_communications?)
      UserMailer.delay.notify_stakeholders_of_new_signup(stakeholder_email, @onboarding_group.id)
    end
  end

  private

  def stakeholder_email
    'mayoclinicpilot@getbetter.com'
  end
end
