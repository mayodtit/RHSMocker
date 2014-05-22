FactoryGirl.define do
  factory :user_request do
    association :user, factory: :member
    subject { user }
    user_request_type
    sequence(:name) {|n| "UserRequest #{n}"}
  end
end
