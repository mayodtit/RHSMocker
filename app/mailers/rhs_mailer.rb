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

  PREMIUM_WELCOME_TEMPLATE_CLARE = 'Meet Clare, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_LAUREN = 'Meet Lauren, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_MEG = 'Meet Meg, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_NINETTE = 'Meet Ninette, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_JENN = 'Meet Jenn, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_ANN = 'Meet Ann, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_JACQUI = 'Meet Jacqui, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_CRYSTAL = 'Meet Crystal, Your PHA 9/22/2014'

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
    when 'ann@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_ANN
    when 'jacqueline@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_JACQUI
    when 'crystal@getbetter.com'
      template = PREMIUM_WELCOME_TEMPLATE_CRYSTAL
    else
      template = PREMIUM_WELCOME_TEMPLATE_CLARE
    end

    mandrill_mail(
      subject: subject,
      from: user.pha.email,
      from_name: user.pha.full_name,
      to: { email: email },
      template: template,
      headers: {
        'Reply-To' => "#{user.pha.full_name} <premium@getbetter.com>"
      },
      vars: {
        FNAME: user.salutation,
        MEMBERNEED: user.nux_answer.try(:phrase) || 'your health needs'
      }
    )
  end

  MAYO_WELCOME_TEMPLATE_CLARE = 'Mayo Pilot Meet Clare, Your PHA 8/10/14'
  MAYO_WELCOME_TEMPLATE_LAUREN = 'Mayo Pilot Meet Lauren, Your PHA 8/10/14'
  MAYO_WELCOME_TEMPLATE_MEG = 'Mayo Pilot Meet Meg, Your PHA 8/10/14'
  MAYO_WELCOME_TEMPLATE_NINETTE = 'Mayo Pilot Meet Ninette, Your PHA 8/10/14'
  MAYO_WELCOME_TEMPLATE_JENN = 'Mayo Pilot Meet Jenn, Your PHA 8/10/14'

  def mayo_pilot_meet_your_pha_email(user, provider)
    case user.pha.try(:email)
    when 'clare@getbetter.com'
      template = MAYO_WELCOME_TEMPLATE_CLARE
    when 'lauren@getbetter.com'
      template = MAYO_WELCOME_TEMPLATE_LAUREN
    when 'meg@getbetter.com'
      template = MAYO_WELCOME_TEMPLATE_MEG
    when 'ninette@getbetter.com'
      template = MAYO_WELCOME_TEMPLATE_NINETTE
    when 'jenn@getbetter.com'
      template = MAYO_WELCOME_TEMPLATE_JENN
    else
      raise 'Must have PHA to send Meet your PHA'
    end

    mandrill_mail(
      subject: 'Meet your Better Personal Health Assistant',
      from: user.pha.email,
      from_name: user.pha.full_name,
      to: { email: user.email },
      template: template,
      headers: {
        'Reply-To' => "#{user.pha.full_name} <premium@getbetter.com>"
      },
      vars: {
        FNAME: user.salutation,
        DRNAME: provider.full_name
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

  WELCOME_CALL_CONFIRMATION = 'Call Confirmation 7/22/14 from Better.'

  def scheduled_phone_call_member_confirmation_email(spc_id)
    spc = ScheduledPhoneCall.find(spc_id)

    mandrill_mail(
      subject: 'Your Better Call Confirmation',
      from: 'premium@getbetter.com',
      from_name: 'Better',
      to: {email: spc.user.email},
      template: WELCOME_CALL_CONFIRMATION,
      headers: {
        'Reply-To' => "Better <premium@getbetter.com>"
      },
      vars: {
        FNAME: spc.user.salutation,
        PHONENUM: spc.callback_phone_number,
        PHA: spc.owner.first_name
      },
      attachments: [
        {
          file: spc.user_confirmation_calendar_event.export,
          filename: 'event.ics',
          mime_type: 'text/calendar'
        }
      ]
    )
  end

  AUTOMATED_ONBOARDING_SURVEY = '"Survey" email on Day 3 of Trial (7/25/14)'

  def automated_onboarding_survey_email(user, pha)
    mandrill_mail(
      subject: 'What can I help you with?',
      from: pha.email,
      from_name: pha.full_name,
      to: {email: user.email},
      template: AUTOMATED_ONBOARDING_SURVEY,
      headers: {
        'Reply-To' => "#{pha.full_name} <#{pha.email}>"
      },
      vars: {
        FNAME: user.salutation,
        PHA: pha.first_name,
        PHA_EMAIL: "#{pha.full_name} <#{pha.email}>"
      },
    )
  end

  AUTOMATED_ONBOARDING_TESTIMONIALS_CLARE = 'Day 8 Email 8/15 Clare'
  AUTOMATED_ONBOARDING_TESTIMONIALS_LAUREN = 'Day 8 Email 8/15 Lauren'
  AUTOMATED_ONBOARDING_TESTIMONIALS_MEG = 'Day 8 Email 8/15 Meg'
  AUTOMATED_ONBOARDING_TESTIMONIALS_NINETTE = 'Day 8 Email 8/15 Ninette'
  AUTOMATED_ONBOARDING_TESTIMONIALS_JENN = 'Day 8 Email 8/15 Jenn'
  AUTOMATED_ONBOARDING_TESTIMONIALS_ANN = 'Day 8 Email 8/15 Ann'
  AUTOMATED_ONBOARDING_TESTIMONIALS_JACQUI = 'Day 8 Email 8/15 Jacqui'
  AUTOMATED_ONBOARDING_TESTIMONIALS_CRYSTAL = 'Day 8 Email 9/22 Crystal'

  def automated_onboarding_testimonials_email(user, pha)
    template = case pha.email
               when 'clare@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_CLARE
               when 'lauren@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_LAUREN
               when 'meg@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_MEG
               when 'ninette@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_NINETTE
               when 'jenn@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_JENN
               when 'ann@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_ANN
               when 'jacqueline@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_JACQUI
               when 'crystal@getbetter.com'
                 AUTOMATED_ONBOARDING_TESTIMONIALS_CRYSTAL
               else
                 AUTOMATED_ONBOARDING_TESTIMONIALS_CLARE
               end

    mandrill_mail(
      subject: "Let's chat",
      from: pha.email,
      from_name: pha.full_name,
      to: {email: user.email},
      template: template,
      headers: {
        'Reply-To' => "#{pha.full_name} <#{pha.email}>"
      },
      vars: {
        FNAME: user.salutation,
        PHA: pha.first_name,
        MEMBERNEED: user.nux_answer.try(:phrase) || 'your health needs'
      },
    )
  end

  def referral_advertisement_email(user)
    mandrill_mail(
      subject: 'Give Better, Get Better',
      from: 'support@getbetter.com',
      from_name: 'Better',
      to: {email: user.email},
      template: 'Referral Program',
      headers: {
        'Reply-To' => 'Better <support@getbetter.com>'
      },
      vars: {
        FNAME: user.salutation,
        PROMO: user.owned_referral_code.code
      },
    )
  end

  MAYO_PILOT_INVITE_TEMPLATE = 'Mayo Pilot Invite Emails'

  def mayo_pilot_invite_email(user, provider)
    mandrill_mail(
      subject: 'Claim your spot in the Better and Mayo Clinic Pilot',
      from: 'hello@getbetter.com',
      from_name: 'Better',
      to: {email: user.email},
      template: MAYO_PILOT_INVITE_TEMPLATE,
      headers: {
        'Reply-To' => 'Better <hello@getbetter.com>'
      },
      vars: {
        FNAME: user.salutation,
        DRNAME: provider.full_name,
        IOS_INVITE_URL: Rails.application.routes.url_helpers.invite_url(user.invitation_token),
        ANDROID_INVITE_URL: Rails.application.routes.url_helpers.android_invite_url(user.invitation_token)
      }
    )
  end
end
