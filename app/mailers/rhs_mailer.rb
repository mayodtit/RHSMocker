class RHSMailer < MandrillMailer::TemplateMailer
  default from: (Rails.env.production? ? 'support@getbetter.com' : "support@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def welcome_to_better_email(email, salutation)
    mandrill_mail(
      subject: 'Welcome to Better',
      to: { email: email },
      template: 'All User Welcome Email v140415',
      vars: {
        FNAME: salutation
      }
    )
  end

  PREMIUM_WELCOME_TEMPLATE_CLARE = 'Welcome to Premium (Clare)'
  PREMIUM_WELCOME_TEMPLATE_LAUREN = 'Welcome to Premium (Lauren)'
  PREMIUM_WELCOME_TEMPLATE_MEG = 'Welcome to Premium (Meg)'
  PREMIUM_WELCOME_TEMPLATE_NINETTE = 'Welcome to Premium (Ninette)'
  PREMIUM_WELCOME_TEMPLATE_JENN = 'Welcome to Premium (Jenn)'

  def welcome_to_premium_email(email)
    user = Member.find_by_email!(email)
    template = case user.pha.try(:email)
               when 'clare@getbetter.com'
                 PREMIUM_WELCOME_TEMPLATE_CLARE
               when 'lauren@getbetter.com'
                 PREMIUM_WELCOME_TEMPLATE_LAUREN
               when 'meg@getbetter.com'
                 PREMIUM_WELCOME_TEMPLATE_MEG
               when 'ninette@getbetter.com'
                 PREMIUM_WELCOME_TEMPLATE_NINETTE
               when 'jenn@getbetter.com'
                 PREMIUM_WELCOME_TEMPLATE_JENN
               else
                 raise 'Must have PHA to send Welcome to Premium'
               end

    mandrill_mail(
      subject: 'Welcome to Better Premium',
      to: { email: email },
      template: template
    )
  end

  def invitation_email(user, url)
    mandrill_mail(
      subject: "You've been invited to Better",
      to: {email: user.email},
      template: 'Invited to Better (generic)',
      vars: {
        FNAME: user.first_name || 'there',
        LINK: url
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

    template_clare   = 'Call Confirmation New - (Clare)'
    template_lauren  = 'Call Confirmation New - (Lauren)'
    template_meg     = 'Call Confirmation New - (Meg)'
    template_ninette = 'Call Confirmation New - (Ninette)'
    template_jenn    = 'Call Confirmation New - (Jenn)'

    t = case from_email
          when 'lauren@getbetter.com' then template_lauren
          when 'meg@getbetter.com' then template_meg
          when 'ninette@getbetter.com' then template_ninette
          when 'jenn@getbetter.com' then template_jenn
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
