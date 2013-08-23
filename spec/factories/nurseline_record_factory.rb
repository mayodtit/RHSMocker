FactoryGirl.define do
  factory :nurseline_record do
    api_user
    sequence(:payload) {|n| "nurseline_record #{n}"}
  end
end
