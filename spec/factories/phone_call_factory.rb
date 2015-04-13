FactoryGirl.define do
  factory :phone_call do
    association :user, factory: :member
    association :creator, factory: :member
    association :to_role, factory: :role
    origin_phone_number "5558888888"
    destination_phone_number "5551234567"
    sequence(:identifier_token) {|n| '%015i' % n}
    twilio_conference_name 'twilio'
    after(:build) { |phone_call| phone_call.send(:initialize_state_machines, :dynamic => :force) }

    trait :with_message do
      message { association(:message, :user => user) }
    end
  end
end
