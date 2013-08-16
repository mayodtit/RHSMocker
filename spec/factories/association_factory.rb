FactoryGirl.define do
  factory :association do
    user
    association :associate, factory: :user
    association_type
  end
end
