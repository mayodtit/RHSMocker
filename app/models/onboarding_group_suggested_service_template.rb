class OnboardingGroupSuggestedServiceTemplate < ActiveRecord::Base
  belongs_to :onboarding_group, inverse_of: :onboarding_group_suggested_service_templates
  belongs_to :suggested_service_template, inverse_of: :onboarding_group_suggested_service_templates

  attr_accessible :onboarding_group, :onboarding_group_id, :suggested_service_template, :suggested_service_template_id

  validates :onboarding_group, :suggested_service_template, presence: true
  validates :suggested_service_template_id, uniqueness: {scope: :onboarding_group_id}
end
