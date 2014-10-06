class WeightSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid
end
