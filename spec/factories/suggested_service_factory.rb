FactoryGirl.define do
  factory :suggested_service do
    association :user, factory: :member
    suggested_service_template

    trait :unoffered do
      state 'unoffered'
    end

    trait :offered do
      state 'offered'
    end

    trait :accepted do
      state 'accepted'
    end
    trait :rejected do
      state 'rejected'
    end
    trait :expired do
      state 'expired'
    end
  end
end
