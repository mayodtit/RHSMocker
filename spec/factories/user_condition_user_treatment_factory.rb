FactoryGirl.define do
  factory :user_condition_user_treatment, aliases: [:user_disease_user_treatment] do
    user_condition
    user_treatment
  end
end
