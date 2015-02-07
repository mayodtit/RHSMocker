class NonProductionMailInterceptor
  def self.delivering_email(message)
    unless deliver?(message)
      recepients = message.to.each.inject{|names, el|names += (','+el)}
      message.subject ="[To:" + recepients + "]"+ message.subject
      message.to = ['test@getbetter.com']
    end
  end

  def self.deliver?(message)
    message.to.any?{|recipient| whitelisted_email?(recipient)}
  end

  def self.whitelisted_email?(email)
    email.match(/.*getbetter\.com|.*testelf.*/).present?
  end
end
