FactoryGirl.define do
  factory :side_effect do
    sequence(:name) {|n| "SideEffect #{n}"}
    description 'May cause excessive nonsensical outbursts'

    trait :with_treatment do
      treatment_side_effects {|tse| [tse.association(:treatment_side_effect)]}
    end
  end
end
