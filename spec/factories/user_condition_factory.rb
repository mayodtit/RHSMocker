FactoryGirl.define do
  factory :user_condition, aliases: [:user_disease] do
    association :user
    association :condition
    start_date { Date.current() }
    end_date { Date.tomorrow() }
    being_treated false
    diagnosed false

    trait :diagnosed do
      diagnosed true
      association :diagnoser, :factory => :user
      diagnosed_date { Date.current() }
    end
  end
end
