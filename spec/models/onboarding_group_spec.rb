require 'spec_helper'

describe OnboardingGroup do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_has_a 'valid factory', :premium
  it_has_a 'valid factory', :mayo_pilot

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :name
    it_validates 'foreign key of', :provider
    it_validates 'inclusion of', :premium
    it_validates 'inclusion of', :mayo_pilot
    it_validates 'inclusion of', :skip_credit_card
    it_validates 'foreign key of', :trial_nux_story
    it_validates 'inclusion of', :skip_automated_communications
    it_validates 'inclusion of', :skip_emails
  end

  describe '#free_trial_ends_at' do
    let(:onboarding_group) { build_stubbed(:onboarding_group) }

    it 'returns nil if not premium' do
      expect(onboarding_group.free_trial_ends_at).to be_nil
    end

    it 'returns an absolute date if supplied without free_trial_days' do
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

    context 'with both free_trial_days and absolute_free_trial_ends_at' do
      it 'returns free_trial_days when calculated day is smaller' do
        onboarding_group.assign_attributes(premium: true, free_trial_days: 1, absolute_free_trial_ends_at: 3.days.from_now)
        expect(onboarding_group.free_trial_ends_at).to eq(Time.now.pacific.end_of_day + 1.day)
      end

      it 'returns absolute_free_trial_ends_at when calculated day is larger' do
        onboarding_group.assign_attributes(premium: true, free_trial_days: 3, absolute_free_trial_ends_at: 1.day.from_now)
        expect(onboarding_group.free_trial_ends_at).to eq(1.day.from_now)
      end
    end
  end

  describe '#subscription_ends_at' do
    let(:onboarding_group) { build_stubbed(:onboarding_group) }

    it 'returns nil if not premium' do
      expect(onboarding_group.subscription_ends_at).to be_nil
    end

    it 'returns an absolute date if supplied without subscription_days' do
      onboarding_group.assign_attributes(premium: true, absolute_subscription_ends_at: Time.now)
      expect(onboarding_group.absolute_subscription_ends_at).to eq(Time.now)
    end

    it 'returns the end of day pacific time if only subscription_days is supplied' do
      onboarding_group.assign_attributes(premium: true, subscription_days: 1)
      expect(onboarding_group.subscription_ends_at).to eq(Time.now.pacific.end_of_day + 1.day)
    end

    context 'with both subscription_days and absolute_subscription_ends_at' do
      it 'returns subscription_days when calculated day is smaller' do
        onboarding_group.assign_attributes(premium: true, subscription_days: 1, absolute_subscription_ends_at: 3.days.from_now)
        expect(onboarding_group.subscription_ends_at).to eq(Time.now.pacific.end_of_day + 1.day)
      end

      it 'returns absolute_subscription_ends_at when calculated day is larger' do
        onboarding_group.assign_attributes(premium: true, subscription_days: 3, absolute_subscription_ends_at: 1.day.from_now)
        expect(onboarding_group.subscription_ends_at).to eq(1.day.from_now)
      end
    end
  end
end
