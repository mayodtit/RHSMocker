class ContentReferenceSerializer < ActiveModel::Serializer
  attributes :id, :referrer_id, :referee_id
  has_one :referee
end
