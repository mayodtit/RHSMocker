FactoryGirl.define do
  factory :user_agreement do
    association :user, :factory => :member
    agreement
    user_agent 'user agent string'
    ip_address '255.255.255.255'
  end
end
