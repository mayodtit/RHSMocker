# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :encounter do
    status "MyString"
    priority "MyString"
    user nil
    checked false
  end
end
