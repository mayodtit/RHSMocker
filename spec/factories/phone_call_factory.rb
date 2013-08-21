FactoryGirl.define do
  factory :phone_call do
    association :user, factory: :member
    message { association(:message, :user => user) }
  end
end
