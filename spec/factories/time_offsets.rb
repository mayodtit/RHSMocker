FactoryGirl.define do
  factory :time_offset do
    offset_type :fixed
    direction :before
    absolute_minutes { 60 * 36 } # 36 hours

    trait :fixed do
      offset_type :fixed
      absolute_minutes { 60 * 36 } # 36 hours
    end

    trait :relative do
      relative_days 2
      relative_minutes_after_midnight { 60 * 10 } # 10 hours, i.e. 10am
    end
  end
end
