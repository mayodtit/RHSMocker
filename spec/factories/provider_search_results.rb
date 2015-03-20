# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider_search_result do
    id ""
    provider_profile_id 1
    provider_search_id 1
    state "MyString"
  end
end
