FactoryGirl.define do
  factory :custom_card do
    sequence(:title) {|n| "CustomCard #{n}"}
    raw_preview "CustomCard raw_preview"

    trait :with_content do
      content
    end
  end
end
