class OnboardingGroupCandidate < ActiveRecord::Base
  belongs_to :onboarding_group, inverse_of: :onboarding_group_candidates
  belongs_to :user, class_name: 'Member',
                    inverse_of: :onboarding_group_candidate

  attr_accessible :onboarding_group, :onboarding_group_id, :email, :user,
                  :user_id

  validates :onboarding_group, :email, presence: true
  validates :email, uniqueness: true
  validates :user, presence: true, if: :user_id
end
