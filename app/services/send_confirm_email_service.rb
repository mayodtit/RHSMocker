class SendConfirmEmailService
  def initialize(user)
    @user = user
  end

  def call
    if (@user.email_confirmed == false) && @user.email_confirmation_token
      UserMailer.delay.confirm_email_email(@user.id)
    end
  end
end
