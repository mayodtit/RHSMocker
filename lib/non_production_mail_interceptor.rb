class NonProductionMailInterceptor
  def self.delivering_email(message)
    unless self.deliver?(message)
      recepients = message.to.each.inject{|names, el|names += (','+el)}
      message.subject ="[To:" + recepients + "]"+ message.subject
      message.to = ['test@getbetter.com']
    end
  end

  def self.deliver?(message)
    message.to.any? {|recipient| recipient.include?('@getbetter.com') }
  end
end
