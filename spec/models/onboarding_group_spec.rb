require 'spec_helper'

describe OnboardingGroup do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'inclusion of', :premium

  describe '#free_trial_ends_at' do
    let(:onboarding_group) { build_stubbed(:onboarding_group) }

    it 'returns nil if not premium' do
      expect(onboarding_group.free_trial_ends_at).to be_nil
    end

    it 'returns an absolute date if supplied' do
      onboarding_group.assign_attributes(premium: true, absolute_free_trial_ends_at: Time.now)
      expect(onboarding_group.free_trial_ends_at).to eq(Time.now)
    end

    it 'returns the end of day pacific time if free_trial_days is supplied' do
      onboarding_group.assign_attributes(premium: true, free_trial_days: 1)
      expect(onboarding_group.free_trial_ends_at).to eq(Time.now.pacific.end_of_day + 1.day)
    end

    it 'returns nil otherwise' do
      onboarding_group.assign_attributes(premium: true)
      expect(onboarding_group.free_trial_ends_at).to be_nil
    end
  end
end
