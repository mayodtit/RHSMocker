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
    subject = user.care_provider? ? "#{invitor.full_name} invited you to care for patients with Better!" : 'Complete your registration to Better'
    mail(to: user.email, subject: subject)
  end

  def assigned_role_email user, assignor
    @assignor = assignor
    @user = user
    mail(to: user.email, subject: "#{assignor.full_name} invited you to care for patients with Better!")
  end

  def scheduled_phone_call_cp_assigned_email(scheduled_phone_call)
    @scheduled_phone_call = scheduled_phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @scheduled_phone_call.owner_assigned_calendar_event.export}
    mail(to: @scheduled_phone_call.owner .email, subject: 'ASSIGNED - Welcome Call')
  end

  def scheduled_phone_call_member_confirmation_email(scheduled_phone_call)
    @scheduled_phone_call = scheduled_phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @scheduled_phone_call.user_confirmation_calendar_event.export}
    mail(to: @scheduled_phone_call.user.email, subject: 'Better Welcome Call Confirmation', from: 'clare@getbetter.com')
  end

  def scheduled_phone_call_cp_confirmation_email(scheduled_phone_call)
    @scheduled_phone_call = scheduled_phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @scheduled_phone_call.owner_confirmation_calendar_event.export}
    mail(to: @scheduled_phone_call.owner.email, subject: 'BOOKED - Welcome Call')
  end

  def waitlist_invite_email(waitlist_entry)
    @waitlist_entry = waitlist_entry
    mail(to: @waitlist_entry.email, subject: 'Claim your account!')
  end
end
