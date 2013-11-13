FactoryGirl.define do
  factory :content do
    sequence(:title) {|x| "Content #{x}"}
    body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "#{x}"}
    show_call_option true
    show_checker_option true
    show_mayo_copyright true
  end

  factory :mayo_content, class: MayoContent do
    sequence(:title) {|x| "MayoContent #{x}"}
    body "HTML body"
    content_type "Content"
    sequence(:document_id) {|x| "MAYO-#{x}"}
    show_call_option true
    show_checker_option true
    show_mayo_copyright true
  end
end
