FactoryGirl.define do
  factory :referral_code do
    association :creator, factory: :member
    sequence(:code) {|n| "Code#{n}"}
  end
end
