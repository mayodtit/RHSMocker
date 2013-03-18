FactoryGirl.define do

  factory :user_weight do
    sequence(:weight) { |n| 80+n }
  end

end
