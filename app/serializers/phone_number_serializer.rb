class PhoneNumberSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :type, :primary, :number
end
