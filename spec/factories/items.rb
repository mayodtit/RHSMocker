FactoryGirl.define do
  factory :item do
    user
    association :resource, factory: :content

    trait :with_timestamps do
      read_at Time.now
      saved_at Time.now
      dismissed_at Time.now
    end

    trait :read do
      state 'read'
      read_at Time.now
     end

    trait :saved do
      state 'saved'
      saved_at Time.now
    end

    trait :dismissed do
      state 'dismissed'
      dismissed_at Time.now
    end
  end
end
