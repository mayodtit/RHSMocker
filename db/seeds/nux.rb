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
                              ordinal: i})
end

NuxStory.upsert_attributes({unique_id: 'SPLASH'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Get Started',
                            show_nav_signup: false,
                            enable_webview_scrolling: false})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: 'Placeholder text for above sign up form',
                            text_footer: 'Placeholder text for below sign up form'})
NuxStory.upsert_attributes({unique_id: 'TRIAL'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false})
NuxStory.upsert_attributes({unique_id: 'CREDIT_CARD'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: 'Placeholder text for above credit card form',
                            text_footer: 'Placeholder text for below credit card form'})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP_SUCCESS'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Sign Up',
                            show_nav_signup: false,
                            enable_webview_scrolling: false})
