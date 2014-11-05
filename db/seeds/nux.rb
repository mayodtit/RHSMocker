LOREM_IPSUM = <<-eof
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur fermentum
nec lorem sit amet sagittis. Sed erat sapien, auctor ac mauris eu,
sollicitudin efficitur tellus. Nunc faucibus justo vitae ex tempus hendrerit.
Etiam ut ultrices ligula. Proin quis lacinia odio, ut aliquam orci.
eof

(1..4).each do |i|
  NuxStory.upsert_attributes({unique_id: "PLACEHOLDER-STORY-#{i}"},
                             {html: LOREM_IPSUM,
                              action_button_text: 'Next',
                              show_nav_signup: false,
                              enable_webview_scrolling: false,
                              ordinal: i,
                              enabled: false})
end

NuxStory.upsert_attributes({unique_id: 'SPLASH'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Get Started',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: false})
QUESTION_TEXT_HEADER = <<-eof
You’re just two steps away from your own Personal Health Assistant. What would you like to focus on during your free trial?
eof
NuxStory.upsert_attributes({unique_id: 'QUESTION'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Get Started',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: QUESTION_TEXT_HEADER,
                            enabled: true})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Meet your PHA',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: nil,
                            text_footer: nil,
                            enabled: true})
NuxStory.upsert_attributes({unique_id: 'TRIAL'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: false})
NuxStory.upsert_attributes({unique_id: 'CREDIT_CARD'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: nil,
                            text_footer: nil,
                            enabled: false})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP_SUCCESS'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Sign Up',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: false})
