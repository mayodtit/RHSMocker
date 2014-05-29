class ReferralCodeSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :onboarding_group_id, :code
end
