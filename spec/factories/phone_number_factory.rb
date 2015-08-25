# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_number do
    type { PhoneNumber::PHONE_NUMBER_TYPES.sample }
    sequence(:number) {|n| "425#{n.to_s.rjust(7,'0')}" }
    primary false

    trait :user_phone do
      association :phoneable, factory: [:member, :premium]
      phoneable_type "User"
    end

    trait :address_phone do
      association :phoneable, factory: :address
      phoneable_type "Address"
    end

    trait :appointment_phone do
      association :phoneable, factory: :appointment
      phoneable_type "Appointment"
    end
  end
end
