require 'spec_helper'

describe ReferralCode do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_onboarding_group
  it_validates 'presence of', :code
  it_validates 'foreign key of', :user
  it_validates 'foreign key of', :creator
  it_validates 'foreign key of', :onboarding_group
end
