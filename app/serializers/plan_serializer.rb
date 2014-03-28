class PlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :updated_at
end
