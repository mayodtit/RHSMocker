FactoryGirl.define do
  factory :custom_card do
    sequence(:title) {|n| "CustomCard #{n}"}
    body "CustomCard body"

    trait :with_content do
      content
    end
  end
end
