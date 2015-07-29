require 'spec_helper'

describe OnboardingGroupSerializer do
  let(:onboarding_group) { create(:onboarding_group) }

  describe 'defaults' do
    it 'renders the onboarding group' do
      result = onboarding_group.serializer.as_json
      expect(result).to eq(
        {
          id: onboarding_group.id,
          name: onboarding_group.name,
          premium: onboarding_group.premium,
          free_trial_days: onboarding_group.free_trial_days,
          absolute_free_trial_ends_at: onboarding_group.absolute_free_trial_ends_at,
          mayo_pilot: onboarding_group.mayo_pilot,
          provider_id: onboarding_group.provider_id,
          provider: nil,
          subscription_days: onboarding_group.subscription_days,
          absolute_subscription_ends_at: onboarding_group.absolute_subscription_ends_at,
          skip_credit_card: onboarding_group.skip_credit_card,
          skip_emails: onboarding_group.skip_emails
        }
      )
    end
  end

  describe 'onboarding_customization' do
    it 'renders the lighter version for onboarding' do
      result = onboarding_group.serializer(onboarding_customization: true).as_json
      expect(result).to eq(
        {
          header_asset_url: nil,
          background_asset_url: nil
        }
      )
    end
  end

  describe 'onboarding_custom_welcome' do
    it 'renders the lighter version for onboarding' do
      result = onboarding_group.serializer(onboarding_custom_welcome: true).as_json
      expect(result).to eq(
        {
          header_asset_url: nil,
          background_asset_url: nil,
          custom_welcome: nil
        }
      )
    end
  end
end
