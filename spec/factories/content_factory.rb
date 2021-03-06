FactoryGirl.define do
  factory :content do
    sequence(:title) {|x| "Content #{x}"}
    raw_body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "#{x}"}
    show_call_option true
    show_checker_option true
    show_mayo_copyright true
    show_mayo_logo true
    has_custom_card false
    sensitive false

    trait :published do
      state 'published'
    end
  end

  factory :mayo_content, class: MayoContent do
    sequence(:title) {|x| "MayoContent #{x}"}
    raw_body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "MAYO-#{x}"}
    show_call_option true
    show_checker_option true
    show_mayo_copyright true

    trait :tos do
      document_id MayoContent::TERMS_OF_SERVICE
    end
  end

  factory :custom_content, class: CustomContent do
    sequence(:title) {|x| "CustomContent #{x}"}
    raw_body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "CUSTOM-#{x}"}
    show_call_option true
    show_checker_option false
    show_mayo_copyright false
  end
end
