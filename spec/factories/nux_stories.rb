FactoryGirl.define do
  factory :nux_story do
    html "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fermentum erat et felis eleifend consequat at id est. Nulla ultricies est justo, non fringilla lacus egestas eget."
    action_button_text 'Next'
    show_nav_signup false
    enable_webview_scrolling false
    sequence(:unique_id) {|n| "NuxStory#{n}"}
  end
end
