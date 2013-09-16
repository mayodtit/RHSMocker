class UserMailer < ActionMailer::Base
  default from: "noreply@getbetter.com"

  def reset_password_email user
    @user = user
    @url = reset_password_users_url(@user.reset_password_token)
    mail(
      :to => user.email,
      :subject => 'Reset Password Instructions for Better')
  end

  def welcome_email user
    @user = user
    mail(
      :to => user.email,
      :subject => 'Better already')
  end

  def invitation_email user
    @user = user
    @url = invite_url(@user.invitation_token)
    mail(to: user.email, subject: 'Complete your registration to Better')
  end
end
