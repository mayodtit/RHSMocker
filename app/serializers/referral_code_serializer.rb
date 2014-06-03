class ReferralCodeSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :onboarding_group_id, :code, :name, :onboarding_group_name

  def onboarding_group_name
    object.onboarding_group.try(:name)
  end
end
