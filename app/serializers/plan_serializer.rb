class PlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :monthly, :created_at, :updated_at
  has_many :plan_offerings
end
