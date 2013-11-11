class UserMailer < ActionMailer::Base
  default from: lambda{ Rails.env.production? ? "noreply@getbetter.com" : "noreply@#{Rails.env}.getbetter.com" }

  def reset_password_email user
    @user = user
    @token = @user.reset_password_token
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

  def invitation_email user, invitor
    @user = user
    @invitor = invitor
    @url = invite_url(@user.invitation_token)
    subject = user.hcp? ? "#{invitor.full_name} invited you to care for patients with Better!" : 'Complete your registration to Better'
    mail(to: user.email, subject: subject)
  end

  def assigned_role_email user, assignor
    @assignor = assignor
    @user = user
    mail(to: user.email, subject: "#{assignor.full_name} invited you to care for patients with Better!")
  end

  def scheduled_phone_call_email(phone_call)
    @phone_call = phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @phone_call.calendar_event.export}
    mail(to: @phone_call.user.email, subject: 'Your phone call with Better')
  end
end
