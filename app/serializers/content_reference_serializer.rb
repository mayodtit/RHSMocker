class ContentReferenceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :referrer_id, :referee_id
  has_one :referee
end
