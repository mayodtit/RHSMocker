class SendDownloadLinkService
  def initialize(phone_number)
    @phone_number = phone_number
  end

  def call
    return unless @user.phone.present?
    TwilioModule.message_now(phone_number, download_text)
  end

  private

  def download_text
    "Download the Better app and get your own Personal Health Assistant http://www.getbetter.com/app"
  end
end
