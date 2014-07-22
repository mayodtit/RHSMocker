class OnboardingGroupCard < ActiveRecord::Base
  belongs_to :onboarding_group
  belongs_to :resource, polymorphic: true

  attr_accessible :onboarding_group, :onboarding_group_id, :resource,
                  :resource_id, :resource_type, :priority

  validates :onboarding_group, :resource, presence: true
  validates :resource_id, uniqueness: {scope: %i(onboarding_group_id resource_type)}
  validates :priority, numericality: {only_integer: true}

  before_validation :set_priority

  private

  def set_priority
    self.priority ||= 0
  end
end
