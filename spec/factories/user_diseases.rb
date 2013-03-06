# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_disease do
    user nil
    disease nil
    start_date "2013-03-05"
    end_date "2013-03-05"
    being_treated false
    diagnosed false
  end
end
