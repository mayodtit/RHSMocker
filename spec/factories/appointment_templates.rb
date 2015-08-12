FactoryGirl.define do
  factory :appointment_template do
    name "Template"
    title "Title"
    description "Description"
    scheduled_at Time.now
    special_instructions "special_instructions"
    reason_for_visit "reason_for_visit"
    trait :published do
      state :published
    end
  end
end
