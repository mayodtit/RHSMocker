class OnboardingGroupProgram < ActiveRecord::Base
  belongs_to :onboarding_group
  belongs_to :program

  attr_accessible :onboarding_group, :onboarding_group_id, :program, :program_id

  validates :onboarding_group, :program, presence: true
  validates :program_id, uniqueness: {scope: :onboarding_group_id}
end
