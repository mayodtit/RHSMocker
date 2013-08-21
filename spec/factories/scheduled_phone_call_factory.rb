FactoryGirl.define do
  factory :scheduled_phone_call do
    association :user, factory: :member
    message { association(:message, :user => user) }
    scheduled_at { Time.now }
  end
end
