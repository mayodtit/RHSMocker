FactoryGirl.define do
  factory :custom_card do
    sequence(:title) {|n| "CustomCard #{n}"}
    raw_preview "CustomCard raw_preview"
    has_custom_card false
    payment_card false
    pha_card false

    trait :with_content do
      content
    end
  end
end
