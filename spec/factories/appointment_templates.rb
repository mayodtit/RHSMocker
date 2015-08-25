FactoryGirl.define do
  factory :appointment_template do
    title "Title"
    description "Description"
    special_instructions "Special instructions"
    reason_for_visit "Reason for visit"

    trait :unpublished do
      state 'unpublished'
    end

    trait :published do
      state 'published'
    end

    trait :retired do
      state 'retired'
    end

    trait :with_scheduled_at_system_event_template do
      scheduled_at_system_event_template {|a| a.association :system_event_template, resource_attribute: :scheduled_at}
    end

    trait :with_discharged_at_system_event_template do
      discharged_at_system_event_template {|a| a.association :system_event_template, resource_attribute: :discharged_at}
    end
  end
end
