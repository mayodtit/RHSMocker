class UserMailer < ActionMailer::Base
  default from: lambda{
    email = Rails.env.production? ? 'support@getbetter.com' : "support@#{Rails.env}.getbetter.com"
    from_address = Mail::Address.new(email)
    from_address.display_name = 'Better'
    from_address.format
  }

  def env
    Rails.env.production? ? '' : "#{Rails.env}: "
  end

  # this method needs to remain since socery doesn't seem to work
  # when using the RHSMailer class for user.reset_password_mailer
  def reset_password_email(user)
    if user.care_provider? then
      url = "#{CARE_URL_PREFIX}/reset_password/#{user.reset_password_token}"
    else
      url = reset_password_users_url(user.reset_password_token)
    end
    Mails::ResetPasswordJob.create(user.id, url)
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

  def notify_of_unassigned_task(task, care_provider)
    subject = "#{env}Task needs triage"

    if task.is_a? MessageTask
      subject = "#{env}Inbound message needs triage"
    elsif task.is_a? PhoneCallTask
      subject = "#{env}Inbound phone call needs triage"
    end

    @task = task
    @care_provider = care_provider
    mail(to: @care_provider.email, subject: subject)
  end

  def notify_of_assigned_task(task, care_provider)
    subject = "#{env}Task assigned to you"

    if task.is_a? MessageTask
      subject = "#{env}Inbound message assigned to you"
    elsif task.is_a? PhoneCallTask
      subject = "#{env}Inbound phone call assigned to you"
    end

    @task = task
    @care_provider = care_provider
    mail(to: @care_provider.email, subject: subject)
  end

  def notify_of_abandoned_task(task, care_provider)
    subject = "#{env}Task has been abandoned"

    @task = task
    @care_provider = care_provider
    mail(to: @care_provider.email, subject: subject)
  end
end
