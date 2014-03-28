FactoryGirl.define do
  factory :plan do
    sequence(:name) {|n| "Plan #{n}"}
    monthly false
  end
end
