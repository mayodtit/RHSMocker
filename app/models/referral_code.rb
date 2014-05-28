class ReferralCode < ActiveRecord::Base
  belongs_to :creator, class_name: 'Member'
  belongs_to :onboarding_group

  attr_accessible :creator, :creator_id, :onboarding_group,
                  :onboarding_group_id, :name, :code

  validates :creator, :code, presence: true
  validates :onboarding_group, presence: true, if: ->(r){r.onboarding_group_id}
end
