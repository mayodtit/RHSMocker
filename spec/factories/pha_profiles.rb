FactoryGirl.define do
  factory :pha_profile do
    association :user, factory: :member
    capacity_weight 100
  end
end
