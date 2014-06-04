FactoryGirl.define do
  factory :address do
    user
    address 'Address line 1'
    address2 'Address line 2'
    city 'City'
    state 'CA'
    postal_code '94301'
  end
end
