# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :time_offset do
    offset_type [:fixed, :relative].sample
    direction [:before, :after].sample
    relative_time Time.at(60 * 60 * 36) ## 36 hours

    fixed_time Time.at(60 * 60 * 10) ## 10 hours, e.g. 10am
    num_days 2
  end
end
