FactoryGirl.define do
  factory :pha_profile do
    association :user, factory: :member
    capacity_weight 100
    mayo_pilot_capacity_weight 0
  end
end
