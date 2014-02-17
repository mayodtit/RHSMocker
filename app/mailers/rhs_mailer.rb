class RHSMailer < MandrillMailer::TemplateMailer
  default from: (Rails.env.production? ? 'noreply@getbetter.com' : "noreply@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def reset_password_email(email, url)
    mandrill_mail(
      subject: 'Reset Password Instructions for Better',
      to: { email: email },
      template: 'Password Reset',
      vars: {
        GREETING: email,
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

    template_clare  = 'Welcome Call Confirmation (Clare) - TEMPLATE v140217'
    template_lauren = 'Welcome Call Confirmation (Lauren) - TEMPLATE v140217'
    t = (from_email == 'lauren@getbetter.com' ? template_lauren : template_clare)

    mandrill_mail(
      subject: 'Better Welcome Call Confirmation',
      from: from_email,
      from_name: spc.owner.full_name,
      to: { email: spc.user.email },
      template: t,
      vars: {
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