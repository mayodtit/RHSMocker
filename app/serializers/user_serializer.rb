class UserSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :blood_pressure, :avatar_url, :weight, :ethnic_group, :diet,
             :full_name, :provider_taxonomy_code, :taxonomy_classification

  def attributes
    super.tap do |attributes|
      if scope.try(:care_provider?)
        attributes.merge!(user_information: object.user_information,
                          address: object.address,
                          insurance_policy: object.insurance_policy,
                          provider: object.provider)
      end
    end
  end

  def full_name
    object.full_name
  end
end
