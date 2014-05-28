FactoryGirl.define do
  factory :pha_profile do
    association :user, factory: :member
  end
end
