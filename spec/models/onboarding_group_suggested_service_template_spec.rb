require 'spec_helper'

describe OnboardingGroupSuggestedServiceTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :onboarding_group
  it_validates 'presence of', :suggested_service_template
  it_validates 'uniqueness of', :suggested_service_template_id, :onboarding_group_id
end
