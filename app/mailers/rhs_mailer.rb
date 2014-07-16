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

  PREMIUM_WELCOME_TEMPLATE_CLARE = 'Meet Clare, Your PHA 7/9/14'
  PREMIUM_WELCOME_TEMPLATE_LAUREN = 'Meet Lauren, Your PHA 7/9/14'
  PREMIUM_WELCOME_TEMPLATE_MEG = 'Meet Meg, Your PHA 7/9/14'
  PREMIUM_WELCOME_TEMPLATE_NINETTE = 'Meet Ninette, Your PHA 7/9/14'
  PREMIUM_WELCOME_TEMPLATE_JENN = 'Meet Jenn, Your PHA 7/9/14'

  def meet_your_pha_email(email)
    user = Member.find_by_email!(email)
    subject = 'Welcome to Better'

    case user.pha.try(:email)
    when 'clare@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_CLARE
    when 'lauren@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_LAUREN
    when 'meg@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_MEG
    when 'ninette@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_NINETTE
    when 'jenn@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_JENN
    else
      raise 'Must have PHA to send Meet your PHA'
    end

    mandrill_mail(
      subject: subject,
      from: user.pha.email,
      from_name: user.pha.full_name,
      to: { email: email },
      template: template,
      headers: {
        'Reply-To' => "#{user.pha.full_name} <premium@getbetter.com>"
      }
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

  WELCOME_CALL_CONFIRMATION_CLARE = 'Call Confirmation Clare 7/9/14'
  WELCOME_CALL_CONFIRMATION_LAUREN = 'Call Confirmation Lauren 7/9/14'
  WELCOME_CALL_CONFIRMATION_MEG = 'Call Confirmation Meg 7/9/14'
  WELCOME_CALL_CONFIRMATION_NINETTE = 'Call Confirmation Ninette 7/9/14'
  WELCOME_CALL_CONFIRMATION_JENN = 'Call Confirmation Jenn 7/9/14'

  def scheduled_phone_call_member_confirmation_email(spc_id)
    spc = ScheduledPhoneCall.find(spc_id)
    from_email = spc.owner.email

    t = case from_email
        when 'clare@getbetter.com'
          WELCOME_CALL_CONFIRMATION_CLARE
        when 'lauren@getbetter.com'
          WELCOME_CALL_CONFIRMATION_LAUREN
        when 'meg@getbetter.com'
          WELCOME_CALL_CONFIRMATION_MEG
        when 'ninette@getbetter.com'
          WELCOME_CALL_CONFIRMATION_NINETTE
        when 'jenn@getbetter.com'
          WELCOME_CALL_CONFIRMATION_JENN
        else
          raise 'Must have PHA to send Welcome Call Confirmation'
        end

    mandrill_mail(
      subject: 'Your Better Call Confirmation',
      from: from_email,
      from_name: spc.owner.full_name,
      to: { email: spc.user.email },
      template: t,
      headers: {
        'Reply-To' => "#{spc.owner.full_name} <premium@getbetter.com>"
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
