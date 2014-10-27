class EnrollmentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :token, :email, :first_name, :last_name, :birth_date,
             :advertiser_id, :time_zone
end
