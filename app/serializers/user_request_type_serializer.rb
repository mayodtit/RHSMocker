class UserRequestTypeSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name

  has_many :user_request_type_fields, key: :fields
end
