module TwilioModule
  @client = Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN

  def client
    @client
  end
end