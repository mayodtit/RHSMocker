class Metadata < ActiveRecord::Base
  attr_accessible :mkey, :mvalue

  validates :mkey, :mvalue, presence: true
  validates :mkey, uniqueness: true

  after_save :alert_stakeholders_when_phas_forced_off_call
  after_save :alert_stakeholders_when_phas_forced_on_call

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.mkey] = metadata.mvalue; hash}
  end

  def self.to_hash_for(user)
    to_hash.tap do |hash|
      hash[:current_user] = user.serializer.as_json
      user.feature_groups.each do |fg|
        hash.merge!(fg.metadata_override) if fg.metadata_override
      end
      hash[:needs_agreement] = true if user.needs_agreement?
      if user.owned_referral_code
        hash[:referral_info] = {
          code: user.owned_referral_code.code,
          url: "http://www.getbetter.com/app",
          title: "Tell a Friend about Better",
          description: "Share your promo code #{user.owned_referral_code.code} with your friends, and they’ll get two weeks of free Better Premium. Once they’ve become a paid Premium member, you’ll both get a month of Premium for free.",
          services: {
            facebook: {
              text: "Simplify your health with Better. Sign up and you’ll get 50% off your first paid month. Your Personal Health Assistant will use Mayo Clinic expertise to do everything from manage your family’s health insurance to crafting custom diet and fitness plans. Referral code is: #{user.owned_referral_code.code}"
            },
            twitter: {
              text: "Change your health with @Betterpha & @mayoclinic. Sign up here to get 50% off your first paid month. Referral code is: #{user.owned_referral_code.code}"
            },
            email: {
              subject: "Get Better with me",
              text: "I joined Better and thought you’d enjoy it too. Sign up and get 50% off your first paid month: http://www.getbetter.com/app\n\nI’m gifting you up to 6 weeks of free membership with your very own Personal Health Assistant who will evaluate your health insurance, fight medical bills, find doctors, make healthy eating plans, and much more. Here is the referral code: #{user.owned_referral_code.code}"
            },
            sms: {
              text: "Get Better with me. Sign up here, and you’ll get 50% off your first paid month of membership with your very own Personal Health Assistant. Here is the referral code: #{user.owned_referral_code.code}"
            },
            default: {
              text: "Get Better with me. Sign up here, and you’ll receive up to 6 weeks of free Premium membership with your very own Personal Health Assistant. Here is the referral code: #{user.owned_referral_code.code}"
            }
          }
        }
      end
    end
  end

  def self.use_invite_flow?
    Metadata.find_by_mkey('use_invite_flow').try(:mvalue) == 'true'
  end

  def self.nurse_phone_number
    Metadata.find_by_mkey('nurse_phone_number').try(:mvalue) || NURSE_PHONE_NUMBER
  end

  def self.direct_nurse_phone_number
    Metadata.find_by_mkey('direct_nurse_phone_number').try(:mvalue) || DIRECT_NURSE_PHONE_NUMBER
  end

  def self.pha_phone_number
    Metadata.find_by_mkey('pha_phone_number').try(:mvalue) || PHA_PHONE_NUMBER
  end

  def self.value_for_key(key)
    find_by_mkey(key).try(:mvalue)
  end

  def self.allow_tos_checked?
    Metadata.find_by_mkey('allow_tos_checked').try(:mvalue) == 'true'
  end

  def self.force_phas_off_call?
    Metadata.find_by_mkey('force_phas_off_call').try(:mvalue) == 'true'
  end

  def self.force_phas_on_call?
    Metadata.find_by_mkey('force_phas_on_call').try(:mvalue) == 'true'
  end

  def self.enable_sharing?
    Metadata.find_by_mkey('enable_sharing').try(:mvalue) == 'true'
  end

  def self.signup_free_trial?
    Metadata.find_by_mkey('signup_free_trial').try(:mvalue) == 'true'
  end

  def self.offboard_free_trial_members?
    Metadata.find_by_mkey('offboard_free_trial_members').try(:mvalue) == 'true'
  end

  def self.offboard_expired_members?
    Metadata.find_by_mkey('offboard_expired_members').try(:mvalue) == 'true'
  end

  def self.new_onboarding_flow?
    Metadata.find_by_mkey('new_onboarding_flow').try(:mvalue) == 'true'
  end

  def self.offboard_free_trial_start_date
    begin
      Time.strptime Metadata.find_by_mkey('offboard_free_trial_start_date').try(:mvalue), '%m/%d/%Y'
    rescue
      1.year.from_now # e.g. don't do offboarding
    end
  end

  def alert_stakeholders_when_phas_forced_off_call
    if mkey == 'force_phas_off_call' && mvalue_changed?
      ScheduledJobs.alert_stakeholders_when_phas_forced_off_call
    end
  end

  def alert_stakeholders_when_phas_forced_on_call
    return unless mkey == 'force_phas_on_call'

    body = mvalue == 'true' ? "ALERT: PHAs are currently forced on call till 9PM PDT." : "OK: PHAs are no longer forced on call."

    Role.pha_stakeholders.each do |s|
      TwilioClient.message s.text_phone_number, body
    end
  end

  def self.on_call_queue_only_inbound_and_unassigned?
    Metadata.find_by_mkey('on_call_queue_only_inbound_and_unassigned').try(:mvalue) == 'true'
  end

  def self.automated_onboarding?
    Metadata.find_by_mkey('automated_onboarding').try(:mvalue) == 'true'
  end

  def self.automated_offboarding?
    Metadata.find_by_mkey('automated_offboarding').try(:mvalue) == 'true'
  end

  def self.ignore_events_from_test_users?
    Metadata.find_by_mkey('ignore_events_from_test_users').try(:mvalue) == 'true'
  end

  def self.nux_question_text
    Metadata.find_by_mkey('nux_question_text').try(:mvalue)
  end

  def self.new_signup_second_message_delay
    delay = Metadata.find_by_mkey('new_signup_second_message_delay').try(:mvalue).to_i
    delay ? delay : 5
  end

  def self.minutes_to_inactive_conversation
    minutes = Metadata.find_by_mkey('minutes_to_inactive_conversation').try(:mvalue).to_i
    (minutes ? minutes : 15).minutes
  end

  def self.triage_off_hours_message?
    Metadata.find_by_mkey('triage_off_hours_message').try(:mvalue) == 'true'
  end

  def self.notify_lack_of_tasks?
    Metadata.find_by_mkey('notify_lack_of_tasks').try(:mvalue) == 'true'
  end

  def self.notify_lack_of_messages?
    Metadata.find_by_mkey('notify_lack_of_messages').try(:mvalue) == 'true'
  end
end
