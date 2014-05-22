FactoryGirl.define do
  factory :user_request_type_field do
    user_request_type
    sequence(:name) {|n| "UserRequestTypeField #{n}"}
    sequence(:type) {|n| "Type#{n}"}
  end
end
