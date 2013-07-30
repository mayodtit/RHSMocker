# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :disease do   
    sequence(:name){|n| "scurvy #{n}" }
  end
end
