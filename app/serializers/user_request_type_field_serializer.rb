class UserRequestTypeFieldSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :type
end
