FactoryGirl.define do
  factory :system_action_template do
    system_event_template
    type :system_message
    message_text 'System action template test text'

    trait :system_message do
      type :system_message
    end

    trait :pha_message do
      type :pha_message
    end

    trait :with_content do
      content
    end

    trait :service do
      type :service
      message_text nil
      published_versioned_resource { association(:service_template, :published) }
    end

    trait :task do
      type :task
      message_text nil
      unversioned_resource { association(:task_template, :with_service_type) }
    end
  end
end
