# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :association do
    user nil
    associate nil
    relation_type "family"
    relation "sister"
  end
end
