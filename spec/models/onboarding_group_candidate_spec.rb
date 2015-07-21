require 'spec_helper'

describe OnboardingGroupCandidate do
  it_has_a 'valid factory'
  it_validates 'presence of', :onboarding_group
  it_validates 'presence of', :email
  it_validates 'uniqueness of', :email
end
