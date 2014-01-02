FactoryGirl.define do
  factory :symptom do
    sequence(:name) {|n| "Symptom #{n}"}
    description 'description'
    patient_type ['adult', 'child'].sample
  end
end
