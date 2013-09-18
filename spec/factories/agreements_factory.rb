FactoryGirl.define do
  factory :agreement do
    text 'agreement text'
    type :terms_of_service
    active false

    trait :active do
      active true
    end

    trait :terms_of_service do
      type :terms_of_service
    end

    trait :privacy_policy do
      type :privacy_policy
    end
  end
end
