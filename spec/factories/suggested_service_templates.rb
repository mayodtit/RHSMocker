FactoryGirl.define do
  factory :suggested_service_template do
    sequence(:title) {|n| "SuggestedServiceTemplate #{n}"}
    description { "Get started on #{title}" }
    message { "I'd like to start #{title}" }
    service_template
  end
end
