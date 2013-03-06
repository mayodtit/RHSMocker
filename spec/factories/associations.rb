# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :association do
    user nil
    relation_type "MyString"
    relation "MyString"
  end
end
