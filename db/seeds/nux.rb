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
What would you like to focus on during your free trial?
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
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: nil,
                            text_footer: nil,
                            enabled: true})

TRIAL_HTML = <<-eof
<html>
  <head>
    <style>
      @font-face {
        font-family: 'Roboto Light';
        font-style: normal;
        font-weight: 300;
        src: local("Roboto Light"), local("Roboto-Light"), url(http://themes.googleusercontent.com/static/fonts/roboto/v9/Hgo13k-tfSpn0qi1SFdUfbO3LdcAZYWl9Si6vvxL-qU.woff) format("woff");
      }

      @font-face {
        font-family: 'Roboto';
        font-style: normal;
        font-weight: 400;
        src: local("Roboto Regular"), local("Roboto-Regular"), url(http://themes.googleusercontent.com/static/fonts/roboto/v9/CrYjSnGjrRCn0pd9VQsnFOvvDin1pK8aKteLpeZ5c0A.woff) format("woff");
      }

      .content {
        font-family: 'Roboto';
        font-size: 16px;
        color: white;
        margin: 50pt 10pt 10pt 10pt;
      }

      #title {
        font-family: 'Roboto Light';
        font-size: 24px;
      }

      #body {
        margin-top: 10pt;
      }
    </style>
  </head>
  <body>
    <div class="content">
      <div id='title'>Try Better free for one month.</div>
      <div id='body'>
        <p>
          Get your own Personal Health Assistant to organize your health information, create a personalized plan based on your needs, and work with you to achieve your health goals.
        </p>
        <p>
          At the end of your trial, your card will be charged $19.99/month. If you cancel your subscription before the trial is over, you will not be charged.
        </p>
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'TRIAL'},
                           {html: TRIAL_HTML,
                            action_button_text: 'Get a month free',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: true})
NuxStory.upsert_attributes({unique_id: 'CREDIT_CARD'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Confirm',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: nil,
                            text_footer: nil,
                            enabled: true})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP_SUCCESS'},
                           {html: TRIAL_HTML,
                            action_button_text: 'Get a month free',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: false})
