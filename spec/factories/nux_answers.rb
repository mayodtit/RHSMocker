# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nux_answer do
    name "answer"
    text "An answer"
    phrase "an answer"
    active true
    ordinal 1
  end
end
