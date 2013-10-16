FactoryGirl.define do
  factory :feature_group do
    sequence(:name) {|x| "Feature Group #{x}"}
  end
end
