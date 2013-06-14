FactoryGirl.define do
  factory :user_disease_treatment_side_effect do
    association :user_disease_treatment
    association :side_effect
  end
end
