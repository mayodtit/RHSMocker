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
  end
end
