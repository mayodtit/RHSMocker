# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :encounters_user do
    role "patient"
    encounter nil
    user nil
  end
end
