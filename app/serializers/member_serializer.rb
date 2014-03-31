class MemberSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :avatar_url, :ethnic_group, :diet, :address,
             :holds_phone_in, :install_id, :phone, :units, :client_data,
             :pusher_id, :full_name, :created_at, :email_read_only,
             :sharing_prohibited, :owner_id, :is_premium, :subscription_end_date,
             :pha_id, :pha_profile_bio_image_url, :pha_profile_url

  def attributes
    super.tap do |attributes|
      if options[:include_roles]
        attributes.merge!(admin?: object.admin?,
                          nurse?: object.nurse?,
                          pha?: object.pha?,
                          pha_lead?: object.pha_lead?,
                          care_provider?: object.care_provider?)
        attributes.merge!(roles: object.roles.map(&:name))
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
    end
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
end
