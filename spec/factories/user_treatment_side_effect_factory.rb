FactoryGirl.define do
  factory :user_treatment_side_effect do
    association :user_treatment
    association :side_effect
  end
end
