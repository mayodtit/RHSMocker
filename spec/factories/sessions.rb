FactoryGirl.define do
  factory :session do
    member
    sequence(:auth_token) { Base64.urlsafe_encode64(SecureRandom.base64(36)) }
  end
end
