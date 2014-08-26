class MemberSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :avatar_url, :ethnic_group, :diet, :address,
             :holds_phone_in, :install_id, :phone, :units, :client_data,
             :full_name, :created_at, :email_read_only,
             :sharing_prohibited, :owner_id, :is_premium, :free_trial_ends_at,
             :pha_id, :pha_profile_bio_image_url, :pha_profile_url,
             :show_welcome_call, :pha_full_name, :last_contact_at,
             :has_master_consult, :subscription_end_date, :subscription_ends_at,
             :invitation_url, :signed_up_at, :has_welcome_call, :device_app_version,
             :device_app_build, :device_timezone, :device_notifications_enabled,
             :device_os, :status, :meet_your_pha_text

  has_one :nux_answer

  def attributes
    if options[:shallow]
      {
        id: object.id,
        avatar_url: object.avatar_url,
        first_name: object.first_name,
        last_name: object.last_name,
        email: object.email,
        full_name: object.full_name
      }
    else
      super.tap do |attributes|
        if options[:include_roles]
          attributes.merge!(admin?: object.admin?,
                            nurse?: object.nurse?,
                            pha?: object.pha?,
                            pha_lead?: object.pha_lead?,
                            care_provider?: object.care_provider?)
          attributes.merge!(roles: object.roles.map(&:name))
          attributes.merge!(on_call?: object.on_call?)
        end

        if options[:include_health_information]
          attributes.merge!(blood_pressure: object.blood_pressure,
                            weight: object.weight)
        end

        if options[:include_nested_information]
          attributes.merge!(user_information: object.user_information,
                            insurance_policy: object.insurance_policy,
                            provider: object.provider,
                            emergency_contact: object.emergency_contact.try(:serializer).try(:as_json))
        end

        if options[:include_onboarding_information]
          attributes.merge!(feature_groups: object.feature_groups,
                            onboarding_group_name: onboarding_group_name,
                            referral_code_name: referral_code_name)
        end
      end
    end
  end

  def has_master_consult
    object.master_consult.present?
  end

  def full_name
    object.full_name
  end

  def email_read_only
    true
  end

  def sharing_prohibited
    true
  end

  def pha_profile_bio_image_url
    object.pha_profile.try(:bio_image_url)
  end

  def pha_profile_url
    if object.pha_profile
      Rails.application.routes.url_helpers.pha_profile_url(object.pha_profile.id)
    end
  end

  def pha_full_name
    object.pha && object.pha.full_name
  end

  def show_welcome_call
    (has_welcome_call && object.scheduled_phone_calls.empty?) || false
  end

  def has_welcome_call
    if object.feature_groups.find_by_name('Launch day A/B test - without onboarding calls')
      false
    else
      true
    end
  end

  # TODO - workaround for client issue, remove after client supports nil value
  # for free premium users (that don't have any Stripe subscriptions)
  def free_trial_ends_at
    if object.is_premium? and object.free_trial_ends_at.nil? and object.stripe_customer_id.nil?
      Time.parse('2099-12-31').in_time_zone
    else
      object.free_trial_ends_at
    end
  end

  def subscription_end_date
    free_trial_ends_at
  end

  def invitation_url
    invite_url(object.invitation_token) if object.invitation_token
  end

  def onboarding_group_name
    object.onboarding_group.try(:name)
  end

  def referral_code_name
    object.referral_code.try(:name)
  end

  def address
    object.addresses.first
  end

  def meet_your_pha_text
    "#{object.pha.try(:first_name)} will be your Personal Assistant. #{object.pha.try(:gender_pronoun).try(:titleize)}’ll start by helping you with #{object.nux_answer.try(:phrase) || 'your health needs'}."
  end
end
