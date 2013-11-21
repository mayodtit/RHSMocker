FactoryGirl.define do
  factory :symptoms_factor do
    symptom
    factor
    factor_group
    doctor_call_worthy false
    er_worthy false
  end
end
