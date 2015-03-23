# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider_search_preference, :class => 'ProviderSearchPreferences' do
    id ""
    lat "37.773"
    lon "-122.413"
    distance "9.99"
    gender "female"
    specialty_uid "MyString"
    insurance_uid "MyString"
  end
end
