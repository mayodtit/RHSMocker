FactoryGirl.define do
  factory :user_request do
    association :user, factory: :member
    subject { user }
    sequence(:name) {|n| "UserRequest #{n}"}
  end
end
