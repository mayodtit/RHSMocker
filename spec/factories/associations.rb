FactoryGirl.define do
  factory :association do
    user
    association :associate, factory: :user
  end
end
