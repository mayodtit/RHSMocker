FactoryGirl.define do
  factory :suggested_service do
    association :user, factory: :member
    association :service_template
  end
end
