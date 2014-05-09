require 'spec_helper'

describe OnboardingGroup do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'inclusion of', :premium
end
