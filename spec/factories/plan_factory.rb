FactoryGirl.define do
  factory :plan do
    sequence(:name) {|n| "Plan #{n}"}
  end
end
