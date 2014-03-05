class MemberSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :avatar_url, :ethnic_group, :diet,
             :holds_phone_in, :install_id, :phone, :units, :client_data,
             :pusher_id, :full_name, :created_at

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
                          address: object.address,
                          insurance_policy: object.insurance_policy,
                          provider: object.provider,
                          emergency_contact: object.emergency_contact.serializer.as_json)
      end
    end
  end

  def full_name
    object.full_name
  end
end
