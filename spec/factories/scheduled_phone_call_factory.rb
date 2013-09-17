FactoryGirl.define do
  factory :scheduled_phone_call do
    association :user, factory: :user_with_email
    message { association(:message, :user => user) }
    scheduled_at { Time.now }
  end
end
