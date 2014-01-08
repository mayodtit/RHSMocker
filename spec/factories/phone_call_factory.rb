FactoryGirl.define do
  factory :phone_call do
    association :user, factory: :member
    message { association(:message, :user => user) }
    origin_phone_number "5558888888"
    destination_phone_number "5551234567"
    sequence(:identifier_token) {|n| '%015i' % n}
  end
end
