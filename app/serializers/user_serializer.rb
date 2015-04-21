class UserSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :work_phone_number,
             :avatar_url, :ethnic_group, :diet, :address,
             :full_name, :provider_taxonomy_code, :taxonomy_classification,
             :email_read_only, :sharing_prohibited, :owner_id, :text_phone_number,
             :due_date

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
        if options[:include_health_information]
          attributes.merge!(blood_pressure: object.blood_pressure,
                            weight: object.weight)
        end

        if options[:include_nested_information]
          attributes.merge!(user_information: object.user_information,
                            provider: object.provider,
                            emergency_contact: object.emergency_contact.try(:serializer).try(:as_json))
        end
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
    object.inverse_associations.joins(:replacement).where('associations.associate_id != replacements_associations.associate_id').any? || (scope && scope.id != object.owner_id)
  end

  def address
    object.addresses.find_by_name("office") || object.addresses.find_by_name("NPI")
  end
end
