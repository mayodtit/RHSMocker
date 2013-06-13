FactoryGirl.define do
  factory :user_disease_treatment_treatment_side_effect do
    association :user_disease_treatment
    association :treatment_side_effect
  end
end
