require 'singleton'

class TwilioClient
  include Singleton

  def self.message(phone_number, body)
    instance.message(phone_number, body)
  end

  def message(phone_number, body)
    return unless phone_number
    body = "#{Rails.env} - #{body}" unless Rails.env.production?
    client.account.messages.create(from: alert_phone_number,
                                   to: format_for_dialing(phone_number),
                                   body: body)
  end

  private

  def client
    @client ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def alert_phone_number
    @alert_phone_number ||= format_for_dialing(environment_phone_number)
  end

  def environment_phone_number
    if Rails.env.production? || Rails.env.qa?
      Metadata.pha_phone_number || SERVICE_ALERT_PHONE_NUMBER
    else
      SERVICE_ALERT_PHONE_NUMBER
    end
  end

  def format_for_dialing(number)
    PhoneNumberUtil::format_for_dialing(number)
  end
end
