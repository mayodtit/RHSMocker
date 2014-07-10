class RHSMailer < MandrillMailer::TemplateMailer
  default from: (Rails.env.production? ? 'support@getbetter.com' : "support@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def welcome_to_better_email(email, salutation)
    mandrill_mail(
      subject: 'Welcome to Better',
      to: { email: email },
      template: 'All User Welcome Email',
      vars: {
        FNAME: salutation
      }
    )
  end

  def welcome_to_better_free_trial_email(email, salutation)
    mandrill_mail(
      subject: 'Welcome to Better Premium',
      to: { email: email },
      template: 'Free Trial Welcome Email',
      vars: {
        FNAME: salutation
      }
    )
  end

  def upgrade_to_better_free_trial_email(email, salutation)
    mandrill_mail(
      subject: "You've been handpicked to try Better Premium",
      to: { email: email },
      template: 'Upgrade to Trial',
      vars: {
        FNAME: salutation
      }
    )
  end

  def welcome_to_premium_email(email, salutation)
    mandrill_mail(
      subject: 'Welcome to Better Premium',
      to: { email: email },
      template: 'PAID Premium User Welcome',
      vars: {
        FNAME: salutation
      }
    )
  end

  PREMIUM_WELCOME_TEMPLATE_CLARE = 'Meet Clare, Your PHA'
  PREMIUM_WELCOME_TEMPLATE_LAUREN = 'Meet Lauren, Your PHA'
  PREMIUM_WELCOME_TEMPLATE_MEG = 'Meet Meg, Your PHA'
  PREMIUM_WELCOME_TEMPLATE_NINETTE = 'Meet Ninette, Your PHA'
  PREMIUM_WELCOME_TEMPLATE_JENN = 'Meet Jenn, Your PHA'

  def meet_your_pha_email(email)
    user = Member.find_by_email!(email)
    case user.pha.try(:email)
    when 'clare@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_CLARE
      subject = 'Meet Clare, your Personal Health Assistant'
    when 'lauren@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_LAUREN
      subject = 'Meet Lauren, your Personal Health Assistant'
    when 'meg@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_MEG
      subject = 'Meet Meg, your Personal Health Assistant'
    when 'ninette@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_NINETTE
      subject = 'Meet Ninette, your Personal Health Assistant'
    when 'jenn@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_JENN
      subject = 'Meet Jenn, your Personal Health Assistant'
    else
      raise 'Must have PHA to send Meet your PHA'
    end

    template += ' 7/9/14' if Metadata.new_onboarding_flow?

    mandrill_mail(
      subject: subject,
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

    template_clare   = 'Call Confirmation Clare'
    template_lauren  = 'Call Confirmation Lauren'
    template_meg     = 'Call Confirmation Meg'
    template_ninette = 'Call Confirmation Ninette'
    template_jenn    = 'Call Confirmation Jenn'

    if Metadata.new_onboarding_flow?
      template_clare += ' 7/9/14'
      template_lauren += ' 7/9/14'
      template_meg += ' 7/9/14'
      template_ninette += ' 7/9/14'
      template_jenn += ' 7/9/14'
    end

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
