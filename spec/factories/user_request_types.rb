FactoryGirl.define do
  factory :user_request_type do
    sequence(:name) {|n| "UserRequestType #{n}"}

    trait :with_fields do
      after(:build) do |urt|
        urt.user_request_type_fields << build(:user_request_type_field, user_request_type: urt)
      end
    end

    factory :appointment_user_request_type, class: UserRequestType do
      name 'appointment'
    end
  end
end
