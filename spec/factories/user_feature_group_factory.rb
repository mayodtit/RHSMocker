FactoryGirl.define do
  factory :user_feature_group do
    association :user, factory: :member
    feature_group
  end
end
