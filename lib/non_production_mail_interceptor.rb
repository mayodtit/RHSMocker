class NonProductionMailInterceptor
  def self.delivering_email(message)
    message.to = ['engineering@getbetter.com']
  end
end
