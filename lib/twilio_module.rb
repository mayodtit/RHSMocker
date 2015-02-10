module TwilioModule
  @client = Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN

  class << self
    def client
      @client
    end

    def message_now(phone_number, body)
      return unless phone_number
      body = "#{Rails.env} - #{body}" unless Rails.env.production?

      client.account.messages.create(
        from: PhoneNumberUtil::format_for_dialing(SERVICE_ALERT_PHONE_NUMBER),
        to: PhoneNumberUtil::format_for_dialing(phone_number),
        body: body
      )
    end

    def message(phone_number, body)
      message_now(phone_number, body)
    end
    handle_asynchronously :message
  end
end
