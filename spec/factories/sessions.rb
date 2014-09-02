FactoryGirl.define do
  factory :session do
    member
    sequence(:auth_token) { Session.new.send(:set_auth_token) }
  end
end
