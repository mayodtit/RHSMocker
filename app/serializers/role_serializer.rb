class RoleSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :on_call?
end
