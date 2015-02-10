class Api::V1::SmsNotificationsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def download
    TwilioModule.message(params[:phone_number], download_text)
    head :ok
  end

  private

  def download_text
    "Download the Better app and get your own Personal Health Assistant http://www.getbetter.com/app"
  end
end
