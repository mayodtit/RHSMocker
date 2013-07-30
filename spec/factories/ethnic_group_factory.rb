FactoryGirl.define do
  factory :ethnic_group do
    sequence(:name) {|n| "Ethnic Group #{n}"}
  end
end
