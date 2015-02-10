class UserAllergySerializer <  ActiveModel::Serializer
  self.root = false

  attributes :allergy_id, :created_at, :id, :updated_at, :user_id
end