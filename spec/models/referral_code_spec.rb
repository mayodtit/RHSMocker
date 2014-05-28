require 'spec_helper'

describe ReferralCode do
  it_has_a 'valid factory'
  it_validates 'presence of', :creator
  it_validates 'presence of', :code
  it_validates 'foreign key of', :onboarding_group
end
