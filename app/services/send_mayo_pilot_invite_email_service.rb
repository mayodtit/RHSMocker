class SendMayoPilotInviteEmailService
  def initialize(user)
    @user = user
  end

  def call
    if @user.onboarding_group.try(:mayo_pilot?) && @user.onboarding_group.try(:provider)
      Mails::MayoPilotInviteJob.create(@user.id, @user.onboarding_group.provider.id)
    end
  end
end
