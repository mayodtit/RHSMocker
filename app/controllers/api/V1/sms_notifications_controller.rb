class Api::V1::SmsNotificationsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def download
    SendDownloadLinkService.new(params[:phone_number]).call
    head :ok
  end
end
