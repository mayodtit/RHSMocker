class UserImageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :image_url, :created_at, :updated_at
end
