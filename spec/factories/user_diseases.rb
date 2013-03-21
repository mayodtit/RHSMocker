# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_disease do
    user nil
    disease nil
    start_date { Date.current()}
    end_date {Date.tomorrow()}
    being_treated false
    diagnosed false
  end
end
