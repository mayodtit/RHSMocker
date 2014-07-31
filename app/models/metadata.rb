class Metadata < ActiveRecord::Base
  attr_accessible :mkey, :mvalue

  validates :mkey, :mvalue, presence: true
  validates :mkey, uniqueness: true

  after_save :alert_stakeholders_when_phas_forced_off_call

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.mkey] = metadata.mvalue; hash}
  end

  def self.to_hash_for(user)
    to_hash.tap do |hash|
      user.feature_groups.each do |fg|
        hash.merge!(fg.metadata_override) if fg.metadata_override
      end
      hash[:needs_agreement] = true if user.needs_agreement?
      if user.owned_referral_code
        hash[:referral_info] = {
          code: user.owned_referral_code.code,
          url: "http://www.getbetter.com/getstarted?code=#{user.owned_referral_code.code}",
          title: "Tell a Friend about Better",
          description: "Share your promo code #{user.owned_referral_code.code} with your friends, and they’ll get two weeks of free Better Premium. Once they’ve become a paid Premium member, you’ll both get a month of Premium for free.",
          services: {
            facebook: {
              text: 'Simplify your health with Better. Sign up and you’ll get up to 6 weeks of free Premium membership. Your Personal Health Assistant will use Mayo Clinic expertise to do everything from manage your family’s health insurance to crafting custom diet and fitness plans.'
            },
            twitter: {
              text: 'Change your health with @Betterpha & @mayoclinic. Sign up here to get up to 6 weeks free.'
            },
            email: {
              subject: "Get Better with me",
              text: "Hey there,\n\nI joined Better's Premium service and thought you'd enjoy it too. Sign up here and get up to 6 weeks free: http://www.getbetter.com/getstarted?code=#{user.owned_referral_code.code}\n\nI'm gifting you 2 weeks of free membership, which means you'll get your very own Personal Health Assistant who can help with everything from evaluating insurance to finding new doctors.  If you decide to continue your membership, we’ll both get a free month!"
            },
            sms: {
              text: "Get Better with me. Sign up here, and you’ll receive up to 6 weeks of free Premium membership with your very own Personal Health Assistant."
            },
            default: {
              text: "Get Better with me. Sign up here, and you’ll receive up to 6 weeks of free Premium membership with your very own Personal Health Assistant."
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

  def self.new_card_design?
    Metadata.find_by_mkey('new_card_design').try(:mvalue) == 'true'
  end

  def self.force_phas_off_call?
    Metadata.find_by_mkey('force_phas_off_call').try(:mvalue) == 'true'
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

  def self.new_onboarding_flow?
    Metadata.find_by_mkey('new_onboarding_flow').try(:mvalue) == 'true'
  end

  def alert_stakeholders_when_phas_forced_off_call
    if mkey == 'force_phas_off_call' && mvalue_changed?
      ScheduledJobs.alert_stakeholders_when_phas_forced_off_call
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
end
