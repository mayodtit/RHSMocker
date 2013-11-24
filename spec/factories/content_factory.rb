FactoryGirl.define do
  factory :content do
    sequence(:title) {|x| "Content #{x}"}
    raw_body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "#{x}"}
    show_call_option true
    show_checker_option true
    show_mayo_copyright true

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
