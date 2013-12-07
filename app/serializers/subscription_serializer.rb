class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :plan_id, :created_at, :updated_at
  has_one :plan
end
