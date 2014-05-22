FactoryGirl.define do
  factory :user_request_type do
    sequence(:name) {|n| "UserRequestType #{n}"}
  end
end
