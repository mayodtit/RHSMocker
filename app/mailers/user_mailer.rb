class UserMailer < ActionMailer::Base
  default from: "test@xtremelabs.com"

  def reset_password_email user
    @user = user
    @url = edit_password_resets_url(@user.reset_password_token)
    mail(
      :to => user.email,
      :subject => 'Reset Password Instructions for RHS')
  end
end
