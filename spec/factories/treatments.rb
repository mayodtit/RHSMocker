FactoryGirl.define do
  factory :treatment do
    sequence(:name) { |n| "penicillin #{n}" }

    factory :medicine_treatment, :class => Treatment::Medicine
    factory :lifestyle_change_treatment, :class => Treatment::LifestyleChange
    factory :supplement_treatment, :class => Treatment::Supplement
    factory :surgery_treatment, :class => Treatment::Surgery
    factory :tests_treatment, :class => Treatment::Tests
    factory :therapy_treatment, :class => Treatment::Therapy
    factory :vaccine_treatment, :class => Treatment::Vaccine
  end
end
