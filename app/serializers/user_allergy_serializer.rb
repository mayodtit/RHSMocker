class UserAllergySerializer <  ActiveModel::Serializer
  self.root = false

  has_one :allergy

  attributes :allergy_id, :created_at, :id, :updated_at, :user_id
end
