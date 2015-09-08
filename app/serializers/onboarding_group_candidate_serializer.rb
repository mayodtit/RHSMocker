class OnboardingGroupCandidateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :onboarding_group_id, :user_id, :email, :first_name, :phone
end
