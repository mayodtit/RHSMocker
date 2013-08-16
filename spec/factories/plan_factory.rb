FactoryGirl.define do
  factory :plan do
    sequence(:name) {|n| "Plan #{n}"}
    monthly false

    trait :with_offering do
      offerings {|p| [p.association(:offering)]}
    end
  end
end
