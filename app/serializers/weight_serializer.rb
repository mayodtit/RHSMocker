class WeightSerializer < ActiveModel::Serializer
  self.root = false

  has_one :creator
  attributes :id, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid,
             :healthkit_source, :creator_id
end
