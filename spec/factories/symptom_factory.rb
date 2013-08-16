# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :symptom do
    name          "Abdominal Pain"
    patient_type  ['adult', 'child'].sample 
  end
end
