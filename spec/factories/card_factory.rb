FactoryGirl.define do
  factory :card do
    user
    association :resource, factory: :content

    trait :saved do
      state 'saved'
      state_changed_at Time.now
    end

    trait :dismissed do
      state 'dismissed'
      state_changed_at Time.now
    end
  end
end
