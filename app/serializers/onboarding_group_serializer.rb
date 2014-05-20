class OnboardingGroupSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :premium, :free_trial_days,
             :absolute_free_trial_ends_at, :users_count

  def users_count
    object.users.count
  end
end
