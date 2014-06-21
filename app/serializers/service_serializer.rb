class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :service_type_id, :created_at, :owner_id
end