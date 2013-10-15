FactoryGirl.define do
  factory :credit do
    association :user, factory: :member
    offering
  end
end
