FactoryGirl.define do
  factory :service_type do
    sequence(:name) { |n| "ServiceType #{n}" }
  end
end
