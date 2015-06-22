class DataFieldSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :type, :data
end
