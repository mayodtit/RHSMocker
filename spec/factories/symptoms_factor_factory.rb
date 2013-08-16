# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :symptoms_factor do
    doctor_call_worthy false
    er_worthy false
    symptom nil
    factor nil
    factor_group nil
  end
end
