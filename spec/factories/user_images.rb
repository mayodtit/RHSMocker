FactoryGirl.define do
  factory :user_image do
    association :user, factory: :member
  end
end
