class MemberSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :first_name, :last_name, :birth_date, :blood_type,
             :diet_id, :email, :ethnic_group_id, :gender, :height,
             :deceased, :date_of_death, :npi_number, :expertise,
             :phone, :nickname, :city, :state, :work_phone_number,
             :blood_pressure, :avatar_url, :weight, :ethnic_group, :diet,
             :holds_phone_in, :install_id, :phone, :units, :client_data,
             :pusher_id, :full_name

  attribute :admin?, key: :admin?
  attribute :nurse?, key: :nurse?
  attribute :pha?, key: :pha?
  attribute :pha_lead?, key: :pha_lead?
  attribute :care_provider?, key: :care_provider?

  def attributes
    super.tap do |attributes|
      if scope.try(:admin?)
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
