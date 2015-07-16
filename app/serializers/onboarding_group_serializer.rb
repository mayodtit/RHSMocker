class OnboardingGroupSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :premium, :free_trial_days,
             :absolute_free_trial_ends_at,
             :mayo_pilot, :provider_id, :provider,
             :subscription_days, :absolute_subscription_ends_at,
             :skip_credit_card, :skip_emails, :custom_welcome

  delegate :id, :name, :header_asset_url, :background_asset_url, to: :object

  def attributes
    if for_onboarding?
      {
        id: id,
        name: name,
        header_asset_url: header_asset_url,
        background_asset_url: background_asset_url,
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

  def for_onboarding?
    options[:for_onboarding]
  end
end
