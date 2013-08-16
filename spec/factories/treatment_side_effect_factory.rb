FactoryGirl.define do
  factory :treatment_side_effect do
    association :treatment
    association :side_effect
  end
end
