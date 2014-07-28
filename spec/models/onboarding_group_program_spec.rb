require 'spec_helper'

describe OnboardingGroupProgram do
  it_has_a 'valid factory'
  it_validates 'presence of', :onboarding_group
  it_validates 'presence of', :program
end
