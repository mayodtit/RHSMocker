FactoryGirl.define do
  factory :phone_call do
    association :user, factory: :member
    message { association(:message, :user => user) }
    origin_phone_number "5558888888"
    destination_phone_number "5551234567"
    sequence(:identifier_token) {|n| '%015i' % n}
    after(:build) { |phone_call| phone_call.send(:initialize_state_machines, :dynamic => :force) }
  end
end
