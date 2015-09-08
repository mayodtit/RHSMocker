class OnboardingGroupCandidate < ActiveRecord::Base
  belongs_to :onboarding_group, inverse_of: :onboarding_group_candidates
  belongs_to :user, class_name: 'Member',
                    inverse_of: :onboarding_group_candidate

  attr_accessible :onboarding_group, :onboarding_group_id, :email, :user,
                  :user_id, :first_name, :phone, :surgery_date, :surgery_time,
                  :notes

  validates :onboarding_group, :email, presence: true
  validates :email, uniqueness: true
  validates :user, presence: true, if: :user_id

  before_validation :strip_attributes

  private

  def strip_attributes
    self.first_name = first_name.try(:strip)
  end
end
