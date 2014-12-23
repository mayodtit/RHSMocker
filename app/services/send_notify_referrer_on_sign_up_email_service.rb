class SendNotifyReferrerOnSignUpEmailService
  def initialize(options={})
    @referrer = options[:referrer]
    @referee = options[:referee]
  end

  def call
    RHSMailer.delay.notify_referrer_of_sign_up(@referrer.id, @referee.id)
  end
end
