class RHSMailer < MandrillMailer::TemplateMailer
  default from: ((Rails.env.production? || Rails.env.demo?) ? 'support@getbetter.com' : "support@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def before_check(params)
    if (!Rails.env.production? && !Rails.env.demo?) && !whitelisted_email?(params[:to][:email])
      params[:subject] = "[To:" + params[:to][:email] + "]" + params[:subject]
      params[:to][:email] = 'test@getbetter.com'
    end
  end

  def whitelisted_email?(email)
    email.match(/.*getbetter\.com|.*testelf.*/).present?
  end

  def send_mail(params)
    before_check(params)
    mandrill_mail(params)
  end

  def welcome_to_better_email(email, salutation)
    params = {
      subject: 'Welcome to Better',
      to: { email: email },
      template: 'All User Welcome Email',
      vars: {
        FNAME: salutation
      }
    }
    send_mail(params)
  end

  WELCOME_TO_BETTER_FREE_TRIAL_TEMPLATE = 'Welcome to Better, Free Version 12/10/2014'
  def welcome_to_better_free_trial_email(email, salutation)
    user = Member.find_by_email!(email)

    params = {
      subject: 'Welcome to Better',
      to: { email: email },
      template: WELCOME_TO_BETTER_FREE_TRIAL_TEMPLATE,
      headers: {
        'Reply-To' => "Better <support@getbetter.com>"
      },
      vars: {
        FNAME: salutation,
        MEMBERNEED: user.nux_answer.try(:phrase) || 'with your health needs'
      }
    }
    send_mail(params)
  end

  def upgrade_to_better_free_trial_email(email, salutation)
    params = {
      subject: "You've been handpicked to try Better Premium",
      to: { email: email },
      template: 'Upgrade to Trial',
      vars: {
        FNAME: salutation
      }
    }
    send_mail(params)
  end

  def welcome_to_premium_email(email, salutation)
    params = {
      subject: 'Welcome to Better',
      to: { email: email },
      template: 'PAID Premium User Welcome',
      vars: {
        FNAME: salutation
      }
    }
    send_mail(params)
  end

  def meet_your_pha_email(email)
    user = Member.find_by_email!(email)
    pha = user.pha
    subject = 'Welcome to Better'

    params = {
      subject: subject,
      from: pha.email,
      from_name: pha.full_name,
      to: { email: email },
      template: meet_your_pha_template(user),
      headers: {
        'Reply-To' => "#{pha.full_name} <premium@getbetter.com>"
      },
      vars: {
        FNAME: user.salutation,
        MEMBERNEED: user.nux_answer.try(:phrase) || 'with your health needs',
        PHA_BIO: pha.pha_profile.try(:first_person_bio),
        PHA_HEADER_URL: meet_your_pha_header_url(pha)
      }
    }
    send_mail(params)
  end

  PREMIUM_WELCOME_TEMPLATE_CLARE = 'Meet Clare, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_LAUREN = 'Meet Lauren, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_MEG = 'Meet Meg, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_NINETTE = 'Meet Ninette, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_JENN = 'Meet Jenn, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_ANN = 'Meet Ann, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_JACQUI = 'Meet Jacqui, Your PHA 9/4/2014'
  PREMIUM_WELCOME_TEMPLATE_CRYSTAL = 'Meet Crystal, Your PHA 9/22/2014'
  PREGNANCY_WELCOME_TEMPLATE = 'Meet Your PHA, Pregnancy'

  def meet_your_pha_template(member)
    if member.nux_answer.try(:name) == 'pregnancy'
      PREGNANCY_WELCOME_TEMPLATE
    else
      case member.pha.try(:email)
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
      when 'ann@getbetter.com'
        PREMIUM_WELCOME_TEMPLATE_ANN
      when 'jacqueline@getbetter.com'
        PREMIUM_WELCOME_TEMPLATE_JACQUI
      when 'crystal@getbetter.com'
        PREMIUM_WELCOME_TEMPLATE_CRYSTAL
      else
        raise 'TEMPLATE NOT FOUND'
      end
    end
  end

  PHA_HEADER_ASSET_CLARE = 'meet_your_pha-clare.png'
  PHA_HEADER_ASSET_LAUREN = 'meet_your_pha-lauren.png'
  PHA_HEADER_ASSET_MEG = 'meet_your_pha-meg.png'
  PHA_HEADER_ASSET_NINETTE = 'meet_your_pha-ninette.png'
  PHA_HEADER_ASSET_JENN = 'meet_your_pha-jenn.png'
  PHA_HEADER_ASSET_ANN = 'meet_your_pha-ann.png'
  PHA_HEADER_ASSET_JACQUI = 'meet_your_pha-jacqui.png'
  PHA_HEADER_ASSET_CRYSTAL = 'meet_your_pha-crystal.png'

  def meet_your_pha_header_asset(pha)
    case pha.try(:email)
    when 'clare@getbetter.com'
      PHA_HEADER_ASSET_CLARE
    when 'lauren@getbetter.com'
      PHA_HEADER_ASSET_LAUREN
    when 'meg@getbetter.com'
      PHA_HEADER_ASSET_MEG
    when 'ninette@getbetter.com'
      PHA_HEADER_ASSET_NINETTE
    when 'jenn@getbetter.com'
      PHA_HEADER_ASSET_JENN
    when 'ann@getbetter.com'
      PHA_HEADER_ASSET_ANN
    when 'jacqueline@getbetter.com'
      PHA_HEADER_ASSET_JACQUI
    when 'crystal@getbetter.com'
      PHA_HEADER_ASSET_CRYSTAL
    else
      raise 'HEADER ASSET NOT FOUND'
    end
  end

  def meet_your_pha_header_url(pha)
    'https://s3-us-west-2.amazonaws.com/btr-static/pha_email_header_images/' + meet_your_pha_header_asset(pha)
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

    params = {
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
    }
    send_mail(params)
  end

  def invitation_email(user, url)
    params = {
      subject: "You've been invited to Better",
      to: {email: user.email},
      template: 'Invited to Better (generic)',
      vars: {
        FNAME: user.first_name || 'there',
        LINK: url
      }
    }
    send_mail(params)
  end

  def reset_password_email(email, salutation, url)
    params = {
      subject: 'Reset Password Instructions for Better',
      to: { email: email },
      template: 'Password Recovery email 2/27/2014',
      vars: {
        GREETING: salutation,
        RESETLINK: url
      }
    }
    send_mail(params)
  end

  def assigned_role_email(email, greeting, url, signature)
    params = {
      subject: "#{signature} invited you to care for patients with Better!",
      to: { email: email },
      template: 'Assigned Role',
      vars: {
        GREETING: greeting,
        URL: url,
        SIGNATURE: signature
      }
    }
    send_mail(params)
  end

  WELCOME_CALL_CONFIRMATION = 'Call Confirmation 7/22/14 from Better.'

  def scheduled_phone_call_member_confirmation_email(spc_id)
    spc = ScheduledPhoneCall.find(spc_id)

    params = {
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
    }
    send_mail(params)
  end

  AUTOMATED_ONBOARDING_SURVEY = '"Survey" email on Day 3 of Trial (7/25/14)'

  def automated_onboarding_survey_email(user, pha)
    params = {
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
      }
    }
    send_mail(params)
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

    params = {
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
        MEMBERNEED: user.nux_answer.try(:phrase) || 'with your health needs'
      }
    }
    send_mail(params)
  end

  MAYO_PILOT_INVITE_TEMPLATE = 'Mayo Pilot Invitation Plain Text (11/28/2014)'

  def mayo_pilot_invite_email(user, provider)
    params = {
      subject: 'Claim your spot in the Better and Mayo Clinic Pilot',
      from: 'hello@getbetter.com',
      from_name: 'The Better and Mayo Clinic Pilot',
      to: {email: user.email},
      template: MAYO_PILOT_INVITE_TEMPLATE,
      headers: {
        'Reply-To' => 'The Better and Mayo Clinic Pilot <hello@getbetter.com>'
      },
      vars: {
        FNAME: user.salutation,
        DRNAME: provider.full_name,
        INVITE_URL: Rails.application.routes.url_helpers.invite_url(user.invitation_token)
      }
    }
    send_mail(params)
  end

  MEET_YOUR_PHA_MONTH_TRIAL_TEMPLATE = 'Meet Your PHA Month Trial 11/10/2014'
  def meet_your_pha_month_trial_email(email)
    user = Member.find_by_email!(email)
    pha = user.pha

    params = {
      subject: 'Welcome to Better',
      from: pha.email,
      from_name: pha.full_name,
      to: { email: email },
      template: MEET_YOUR_PHA_MONTH_TRIAL_TEMPLATE,
      headers: {
        'Reply-To' => "#{pha.full_name} <premium@getbetter.com>"
      },
      vars: {
        FNAME: user.salutation,
        MEMBERNEED: user.nux_answer.try(:phrase) || 'with your health needs',
        PHA_BIO: pha.pha_profile.try(:first_person_bio),
        PHA_HEADER_URL: meet_your_pha_header_url(pha)
      }
    }
    send_mail(params)
  end

  def notify_trial_will_end(event)
    customer = event.data.object.customer
    user = User.find_by_stripe_customer_id(customer)
    return if user.nil?
    plan_name = Stripe::Customer.retrieve(customer).subscriptions.data.first.plan.name
    return if user.pha.nil?
    pha_first_name = user.pha.first_name
    params = {
        subject: "Your trial is ending soon",
        from: 'support@getbetter.com',
        from_name: 'Better',
        template: "Free month ending (email support) 2/16/2015",
        to: {email: user.email},
        vars: {
          FNAME: user.salutation,
          PLAN_NAME: plan_name,
          pha_first_name: pha_first_name
        }
    }
    send_mail(params)
  end

  def confirm_subscription_deletion(user)
    params = {
        subject: 'Your subscription has ended',
        from: 'support@getbetter.com',
        from_name: 'Better',
        template: "Account downgraded 2/16/2015",
        to: {email: user.email},
        vars: {
          FNAME: user.salutation,
        }
    }
    send_mail(params)
  end

  def confirm_subscription_change(user, subscription)
    plan_name = subscription.plan.name

    mandrill_mail(
        subject: 'Your subscription has been updated',
        from: "support@getbetter.com",
        from_name: 'Better',
        to: { email: user.email },
        template: "Subscription update 2/16/2015",
        vars: {
          FNAME: user.salutation,
          PLAN_NAME: plan_name
        }
    )
  end
end
