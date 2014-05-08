class OnboardingGroup < ActiveRecord::Base
  attr_accessible :name, :premium, :free_trial_days, :free_trial_ends_at

  validates :name, presence: true
  validates :premium, inclusion: {in: [true, false]}
end
