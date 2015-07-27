class DataFieldSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :type, :data, :required_for_service_start
end
