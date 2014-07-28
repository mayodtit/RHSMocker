require 'spec_helper'

describe OnboardingGroupCard do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_priority)
    end

    it_validates 'presence of', :onboarding_group
    it_validates 'presence of', :resource
    it_validates 'uniqueness of', :resource_id, :onboarding_group_id, :resource_type
    it_validates 'numericality of', :priority
    it_validates 'integer numericality of', :priority
  end
end
