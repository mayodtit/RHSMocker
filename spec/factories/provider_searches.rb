# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider_search do
    id ""
    provider_search_preferences_id 1
    state "MyString"
    user_id 1
  end
end
