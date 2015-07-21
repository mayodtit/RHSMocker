class OnboardingGroupCandidate < ActiveRecord::Base
  belongs_to :onboarding_group, inverse_of: :onboarding_group_candidates

  attr_accessible :onboarding_group, :onboarding_group_id

  validates :onboarding_group, :email, presence: true
  validates :email, uniqueness: true
end
