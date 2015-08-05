FactoryGirl.define do
  factory :appointment_template do
    name "Template"
    title "Title"
    description "Description"
    scheduled_at Time.now
    trait :published do
      state :published
    end
  end
end
