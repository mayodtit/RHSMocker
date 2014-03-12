class UserSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :avatar_url, :ethnic_group, :diet, :address,
             :full_name, :provider_taxonomy_code, :taxonomy_classification,
             :email_read_only, :sharing_prohibited

  def attributes
    super.tap do |attributes|
      if options[:include_health_information]
        attributes.merge!(blood_pressure: object.blood_pressure,
                          weight: object.weight)
      end

      if options[:include_nested_information]
        attributes.merge!(user_information: object.user_information,
                          insurance_policy: object.insurance_policy,
                          provider: object.provider)
      end
    end
  end

  def full_name
    object.full_name
  end

  def email_read_only
    object.inverse_associations.joins(:replacement).any?
  end

  def sharing_prohibited
    object.inverse_associations.joins(:replacement).where('associations.associate_id != replacements_associations.associate_id').any?
  end
end
