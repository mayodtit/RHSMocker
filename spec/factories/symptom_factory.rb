FactoryGirl.define do
  factory :symptom do
    name "Symptom name"
    description "Symptom description"
    patient_type  ['adult', 'child'].sample
  end
end
