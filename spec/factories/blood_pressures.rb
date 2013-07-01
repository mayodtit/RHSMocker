FactoryGirl.define do
  factory :blood_pressure do
    association :user
    association :collection_type
    sequence(:systolic) {|n| 80+n}
    sequence(:diastolic) {|n| 80+n}
    sequence(:pulse) {|n| 80+n}
    taken_at { DateTime.now }
  end
end
