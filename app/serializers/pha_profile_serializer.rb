class PhaProfileSerializer < ActiveModel::Serializer
  self.root = false

  has_one :user
  attributes :id, :user_id, :bio_image_url, :bio, :weekly_capacity,
             :capacity_weight, :full_page_bio_image_url,
             :mayo_pilot_capacity_weight
end
