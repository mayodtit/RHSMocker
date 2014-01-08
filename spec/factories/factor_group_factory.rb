FactoryGirl.define do
  factory :factor_group do
    symptom
    sequence(:name) {|n| "FactorGroup #{n}"}
  end
end
