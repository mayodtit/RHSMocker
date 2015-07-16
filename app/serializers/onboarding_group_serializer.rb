class OnboardingGroupSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :premium, :free_trial_days,
             :absolute_free_trial_ends_at,
             :mayo_pilot, :provider_id, :provider,
             :subscription_days, :absolute_subscription_ends_at,
             :skip_credit_card, :skip_emails, :custom_welcome

  delegate :header_asset_url, :background_asset_url, :custom_welcome, to: :object

  def attributes
    if onboarding_customization?
      {
        background_asset_url: background_asset_url,
        header_asset_url: header_asset_url,
      }
    elsif onboarding_custom_welcome?
      {
        background_asset_url: background_asset_url,
        header_asset_url: header_asset_url,
        custom_welcome: custom_welcome
      }
    else
      super
    end
  end

  def provider
    return nil unless object.provider
    object.provider.as_json(only: :full_name,
                            methods: :full_name)
  end

  private

  def onboarding_customization?
    options[:onboarding_customization]
  end

  def onboarding_custom_welcome?
    options[:onboarding_custom_welcome]
  end
end
