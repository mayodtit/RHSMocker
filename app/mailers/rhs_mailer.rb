class RHSMailer < MandrillMailer::TemplateMailer
  default from: (Rails.env.production? ? 'noreply@getbetter.com' : "noreply@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def welcome_to_premium_email(email, salutation)
    mandrill_mail(
      subject: 'Welcome to Better Premium',
      to: { email: email },
      template: 'Welcome to Better Premium v140310',
      vars: {
        FNAME: salutation
      }
    )
  end

  def reset_password_email(email, salutation, url)
    mandrill_mail(
      subject: 'Reset Password Instructions for Better',
      to: { email: email },
      template: 'Password Reset',
      vars: {
        GREETING: salutation,
        RESETLINK: url
      }
    )
  end

  def assigned_role_email(email, greeting, url, signature)
    mandrill_mail(
      subject: "#{signature} invited you to care for patients with Better!",
      to: { email: email },
      template: 'Assigned Role',
      vars: {
        GREETING: greeting,
        URL: url,
        SIGNATURE: signature
      }
    )
  end

  def scheduled_phone_call_member_confirmation_email(spc_id)
    spc = ScheduledPhoneCall.find(spc_id)
    from_email = spc.owner.email

    template_clare   = 'Welcome Call Confirmation - Clare v140312'
    template_lauren  = 'Welcome Call Confirmation - Lauren v140312'
    template_meg     = 'Welcome Call Confirmation - Meg v140312'
    template_ninette = 'Welcome Call Confirmation - Ninette v140312'

    t = case from_email
          when 'lauren@getbetter.com' then template_lauren
          when 'meg@getbetter.com' then template_meg
          when 'ninette@getbetter.com' then template_ninette
          else template_clare
        end

    mandrill_mail(
      subject: 'Better Welcome Call Confirmation',
      from: from_email,
      from_name: spc.owner.full_name,
      to: { email: spc.user.email },
      template: t,
      headers: {
        'Reply-To' => 'premium@getbetter.com'
      },
      vars: {
        FNAME: spc.user.salutation,
        PHONENUM: spc.callback_phone_number
      },
      attachments: [
        { file: spc.user_confirmation_calendar_event.export,
          filename: 'event.ics',
          mime_type: 'text/calendar' }
      ]
    )
  end
end
