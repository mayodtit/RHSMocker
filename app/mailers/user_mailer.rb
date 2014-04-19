class UserMailer < ActionMailer::Base
  default from: lambda{
    email = Rails.env.production? ? 'noreply@getbetter.com' : "noreply@#{Rails.env}.getbetter.com"
    from_address = Mail::Address.new(email)
    from_address.display_name = 'Better'
    from_address.format
  }

  def env
    "#{Rails.env}: " unless Rails.env.production?
  end

  # this method needs to remain since socery doesn't seem to work
  # when using the RHSMailer class for user.reset_password_mailer
  def reset_password_email(user)
    if user.care_provider? then
      url = "#{CARE_URL_PREFIX}/reset_password/#{user.reset_password_token}"
    else
      url = reset_password_users_url(user.reset_password_token)
    end
    RHSMailer.reset_password_email(user.email, user.salutation, url).deliver
  end

  def invitation_email user, invitor
    @user = user
    @invitor = invitor
    @url = invite_url(@user.invitation_token)
    subject = user.care_provider? ? "#{env}#{invitor.full_name} invited you to care for patients with Better!" : "#{env}Complete your registration to Better"
    mail(to: user.email, subject: subject)
  end

  def scheduled_phone_call_cp_assigned_email(scheduled_phone_call)
    @scheduled_phone_call = scheduled_phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @scheduled_phone_call.owner_assigned_calendar_event.export}
    mail(to: @scheduled_phone_call.owner.email, subject: "#{env}Assigned Welcome Call")
  end

  def scheduled_phone_call_cp_confirmation_email(scheduled_phone_call)
    @scheduled_phone_call = scheduled_phone_call
    attachments['event.ics'] = {:mime_type => 'text/calendar', :content => @scheduled_phone_call.owner_confirmation_calendar_event.export}
    mail(to: @scheduled_phone_call.owner.email, subject: "#{env}Member Booked Welcome Call")
  end

  def notify_phas_of_new_task
    to = 'testphone@getbetter.com'
    to = 'pha@getbetter.com' if Rails.env.production?

    mail(to: to, subject: "#{env}New Task in Queue - Care Portal#{" #{Rails.env}" unless Rails.env.production?}")
  end

  def notify_pha_of_new_member(member)
    @member = member
    @pha = member.pha
    return unless @pha
    mail(to: @pha.email, subject: "#{env} Assigned New Member")
  end
end
