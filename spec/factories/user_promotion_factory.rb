FactoryGirl.define do
  factory :user_promotion do
    association :user
    association :promotion
  end
end
