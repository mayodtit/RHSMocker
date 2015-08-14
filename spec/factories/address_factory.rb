FactoryGirl.define do
  factory :address do
    user
    appointment
    address 'Address line 1'
    address2 'Address line 2'
    city 'City'
    state 'CA'
    postal_code '94301'

    trait :home do
      name :home
    end

    trait :work do
      name :work
    end
  end
end
