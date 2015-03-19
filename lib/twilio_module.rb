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
        from: alert_phone_number,
        to: PhoneNumberUtil::format_for_dialing(phone_number),
        body: body
      )
    end

    def alert_phone_number
      if Rails.env.production? || Rails.env.qa? || Rails.env.demo?
        format_for_dialing(Metadata.outbound_calls_number || SERVICE_ALERT_PHONE_NUMBER)
      else
        format_for_dialing(SERVICE_ALERT_PHONE_NUMBER)
      end
    end

    def format_for_dialing(phone_number)
      PhoneNumberUtil::format_for_dialing(phone_number)
    end

    def message(phone_number, body)
      message_now(phone_number, body)
    end
    handle_asynchronously :message
  end
end
