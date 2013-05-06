FactoryGirl.define do

  factory :blood_pressure do
    sequence(:systolic) { |n| 80+n }
    sequence(:diastolic) { |n| 80+n }
    sequence(:pulse) { |n| 80+n }
    collection_type_id 1
    taken_at { DateTime.now }
  end

end
