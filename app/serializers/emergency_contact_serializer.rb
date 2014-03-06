class EmergencyContactSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :designee_id, :name, :phone_number, :created_at, :updated_at
end
