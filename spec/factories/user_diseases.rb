# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_disease do
    user nil
    disease nil
    start_date {Date.current()}
    end_date {Date.tomorrow()}
    being_treated false
    diagnosed false

    trait :diagnosed do
      association :diagnoser, :factory => :user
      diagnosed true
      diagnosed_date { Date.current() }
    end
  end
end
