FactoryGirl.define do
  factory :suggested_service do
    association :user, factory: :member
    suggested_service_template
  end
end
