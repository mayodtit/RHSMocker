FactoryGirl.define do
  factory :plan do
    sequence(:name) {|n| "Plan #{n}"}
    monthly false

    trait :with_offering do
      plan_offerings {|p| [p.association(:plan_offering)]}
    end
  end
end
