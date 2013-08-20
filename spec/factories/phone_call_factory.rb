FactoryGirl.define do
  factory :phone_call do
    association :user, factory: :member
  end
end
