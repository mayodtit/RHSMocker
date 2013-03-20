# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_status do
    message nil
    user nil
    status "MyString"
  end
end
