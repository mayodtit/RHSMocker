LOREM_IPSUM = <<-eof
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur fermentum
nec lorem sit amet sagittis. Sed erat sapien, auctor ac mauris eu,
sollicitudin efficitur tellus. Nunc faucibus justo vitae ex tempus hendrerit.
Etiam ut ultrices ligula. Proin quis lacinia odio, ut aliquam orci.
eof

logo_base64 = ActiveSupport::Base64.encode64(open("https://s3-us-west-2.amazonaws.com/btr-static/images/logo.png"){|io| io.read})

SPLASH_HTML = <<-eof
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

      #logo {
        margin: 120px auto 0px;
        width: 60%;
      }

      #logo-image {
        max-width: 100%;
      }

      #body {
        margin-top: 10pt;
      }

      #subtitle {
        text-align: center;
        width: 150px;
        margin: 10px auto;
      }
    </style>
  </head>
  <body>
    <div class="content">
      <div id="logo">
        <img id="logo-image" src="data:image/png;base64,#{logo_base64}" alt="logo.png">
      </div>
      <div id="body">
        <p id="subtitle">Get the health care you deserve.</p>
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'SPLASH'},
                           {html: SPLASH_HTML,
                            action_button_text: 'Get started',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: true})

intro_base64 = ActiveSupport::Base64.encode64(open("https://s3-us-west-2.amazonaws.com/btr-static/images/Lauren-Square.png"){|io| io.read})

INTRO_HTML = <<-eof
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

      #content {
        font-family: 'Roboto';
        font-size: 16px;
        color: white;
        text-align: center;
      }

      #title {
        font-size: 24px;
        font-family: 'Roboto';
      }

      #subtitle {
        margin: 10px;
      }

      #image-container {
        width: 50%;
        margin: 30px auto 10px;
      }

      #image {
        max-width: 100%;
      }

      #image-caption-title {
        font-size: 24px;
        font-family: 'Roboto';
      }

      #image-caption-subtitle {
        width: 200px;
        margin: 0px auto;
      }
    </style>
  </head>
  <body>
    <div id="content">
      <div id="title">
        You deserve Better.
      </div>
      <div id="subtitle">
        With a Personal Health Assistant, you'll always have someone on your side to make sure your health comes first.
      </div>
      <div id="image-container">
        <img id="image" src="data:image/png;base64,#{intro_base64}" alt="image" />
      </div>
      <div id="image-caption-title">
        Lauren
      </div>
      <div id="image-caption-subtitle">
        One of Better's Personal Health Assistants
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'INTRO'},
                           {html: INTRO_HTML,
                            action_button_text: 'Learn more',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            ordinal: 1,
                            enabled: true})

intro_pha_base64 = ActiveSupport::Base64.encode64(open("https://s3-us-west-2.amazonaws.com/btr-static/images/Checklist.png"){|io| io.read})

INTRO_PHA_HTML = <<-eof
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

      #content {
        font-family: 'Roboto Light';
        font-size: 16px;
        color: white;
        text-align: center;
      }

      #title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #subtitle {
        margin: 40px 10px 10px;
        font-family: 'Roboto';
      }

      #image-container {
        width: 90%;
        margin: 10px auto;
      }

      #image {
        max-width: 100%;
      }

      #image-caption-title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #image-caption-subtitle {
        width: 200px;
        margin: 0px auto;
      }
    </style>
  </head>
  <body>
    <div id="content">
      <div id="subtitle">
        Your PHA takes care of time-consuming and complicated health tasks so you don't have to.
      </div>
      <div id="image-container">
        <img id="image" src="data:image/png;base64,#{intro_pha_base64}" alt="image" />
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'INTRO_PHA'},
                           {html: INTRO_PHA_HTML,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            ordinal: 2,
                            enabled: true})

intro_available_base64 = ActiveSupport::Base64.encode64(open("https://s3-us-west-2.amazonaws.com/btr-static/images/iPhoneDemo-2.png"){|io| io.read})

INTRO_AVAILABLE_HTML = <<-eof
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

      #content {
        font-family: 'Roboto Light';
        font-size: 16px;
        color: white;
        text-align: center;
      }

      #title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #subtitle {
        margin: 40px 10px 10px;
        font-family: 'Roboto';
      }

      #image-container {
        width: 85%;
        margin: 10px auto;
      }

      #image {
        max-width: 100%;
      }

      #image-caption-title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #image-caption-subtitle {
        width: 200px;
        margin: 0px auto;
      }
    </style>
  </head>
  <body>
    <div id="content">
      <div id="subtitle">
        Health doesn't happen on a schedule, with Better you now have expertise when you need it.
      </div>
      <div id="image-container">
        <img id="image" src="data:image/png;base64,#{intro_available_base64}" alt="image" />
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'INTRO_AVAILABLE'},
                           {html: INTRO_AVAILABLE_HTML,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            ordinal: 3,
                            enabled: true})

intro_personal_base64 = ActiveSupport::Base64.encode64(open("https://s3-us-west-2.amazonaws.com/btr-static/images/Lauren-Messaging-2.png"){|io| io.read})

INTRO_PERSONAL_HTML = <<-eof
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

      #content {
        font-family: 'Roboto Light';
        font-size: 16px;
        color: white;
        text-align: center;
      }

      #title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #subtitle {
        margin: 40px 10px 10px;
        font-family: 'Roboto';
      }

      #image-container {
        width: 90%;
        margin: 10px auto;
      }

      #image {
        max-width: 100%;
      }

      #image-caption-title {
        font-size: 20px;
        font-family: 'Roboto';
      }

      #image-caption-subtitle {
        width: 200px;
        margin: 0px auto;
      }
    </style>
  </head>
  <body>
    <div id="content">
      <div id="subtitle">
        Whatever your health goals are, your PHA is dedicated to helping you and your family achieve them.
      </div>
      <div id="image-container">
        <img id="image" src="data:image/png;base64,#{intro_personal_base64}" alt="image" />
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'INTRO_PERSONAL'},
                           {html: INTRO_PERSONAL_HTML,
                            action_button_text: 'Next',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            ordinal: 4,
                            enabled: true})

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
      <div id='title'>Try Better for Free</div>
      <div id='body'>
        <p>
          Get your own Personal Health Assistant to organize your health information, create a personalized plan based on your needs, and work with you to achieve your health goals.
        </p>
        <p>
          At the end of your free month, your card will be charged $19.99/month. You can cancel anytime during your free month and you will not be charged.
        </p>
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'TRIAL'},
                           {html: TRIAL_HTML,
                            action_button_text: 'Continue',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: true})
NuxStory.upsert_attributes({unique_id: 'CREDIT_CARD'},
                           {html: LOREM_IPSUM,
                            action_button_text: 'Start your free month',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            text_header: 'Enter your credit card information to get your free month.',
                            text_footer: nil,
                            enabled: true,
                            secondary_action_button_text: 'No thanks.'})
NuxStory.upsert_attributes({unique_id: 'SIGN_UP_SUCCESS'},
                           {html: TRIAL_HTML,
                            action_button_text: 'Get a month free',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: false})

TWIST_TRIAL_HTML = <<-eof
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
      <div id='title'>Try Better for Free</div>
      <div id='body'>
        <p>
          Get your own Personal Health Assistant to organize your health information, create a personalized plan based on your needs, and work with you to achieve your health goals.
        </p>
        <p>
          Thanks to Jason Calacanis and TWIST, you’ll be provided with a free month of Better and 50% off your first paid month. That’s six weeks of the health care you deserve, thanks to @jason.
        </p>
      </div>
    </div>
  </body>
</html>
eof

NuxStory.upsert_attributes({unique_id: 'TWIST_TRIAL'},
                           {html: TWIST_TRIAL_HTML,
                            action_button_text: 'Continue',
                            show_nav_signup: false,
                            enable_webview_scrolling: false,
                            enabled: true})
