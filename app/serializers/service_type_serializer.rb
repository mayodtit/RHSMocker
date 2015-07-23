class ServiceTypeSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :bucket, :description_template, :created_at, :updated_at
end
