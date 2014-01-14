FactoryGirl.define do
  factory :agreement do
    text 'agreement text'
    active false

    trait :active do
      active true
    end
  end
end
