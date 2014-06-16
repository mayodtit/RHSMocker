class PhaProfileSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :bio_image_url, :bio, :weekly_capacity
end
