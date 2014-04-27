FactoryGirl.define do
  factory :pha_profile do
    association :user, factory: :member
    accepting_new_members false
  end
end
