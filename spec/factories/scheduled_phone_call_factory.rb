FactoryGirl.define do
  factory :scheduled_phone_call do
    scheduled_at { Time.now }
  end
end
