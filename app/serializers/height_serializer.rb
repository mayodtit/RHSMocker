class HeightSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :amount, :taken_at, :healthkit_uuid
end
