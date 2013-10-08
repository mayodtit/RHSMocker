FactoryGirl.define do
  factory :question do
    sequence(:title) {|x| "Question #{x}"}
    sequence(:view) {|x| "view#{x}"}
  end
end
