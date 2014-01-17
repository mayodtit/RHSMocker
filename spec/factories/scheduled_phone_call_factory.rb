FactoryGirl.define do
  factory :scheduled_phone_call do
    scheduled_at { 2.days.from_now }

    trait :assigned do
      state 'assigned'
    end
  end
end
