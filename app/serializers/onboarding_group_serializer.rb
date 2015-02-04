class OnboardingGroupSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :premium, :free_trial_days,
             :absolute_free_trial_ends_at,
             :mayo_pilot, :provider_id, :provider,
             :subscription_days, :absolute_subscription_ends_at,
             :skip_credit_card

  def provider
    return nil unless object.provider
    object.provider.as_json(only: :full_name,
                            methods: :full_name)
  end
end
