FactoryGirl.define do
  factory :item do
    user
    association :resource, factory: :content

    trait :read do
      state 'read'
     end

    trait :saved do
      state 'saved'
    end

    trait :dismissed do
      state 'dismissed'
    end
  end
end
