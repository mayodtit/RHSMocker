class WeightSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :amount, :bmi, :taken_at
end
