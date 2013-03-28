# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_call do
    time_to_call "2013-03-26 16:05:32"
    status "MyString"
    summary "MyText"
    start_time "2013-03-26 16:05:32"
    message nil
  end
end
