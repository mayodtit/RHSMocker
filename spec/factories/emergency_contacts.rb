FactoryGirl.define do
  factory :emergency_contact do
    association :user, factory: :member
    name 'Your Mom'
    phone_number '5555555555'

    trait :with_designee do
      association :designee, factory: :user
    end
  end
end
