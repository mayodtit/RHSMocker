# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :association_type do
    name "sister"
    relationship_type "family"
    gender "male"
  end
end
