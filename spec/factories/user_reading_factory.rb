FactoryGirl.define do
  factory :user_reading do
    association :user, factory: :member
    content
  end
end
