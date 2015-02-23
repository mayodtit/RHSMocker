class NotifyReferrerWhenRefereeSignUpService
  def initialize(options={})
    @referrer = options[:referrer]
    @referee = options[:referee]
  end

  def call
    Mails::NotifyReferrerOfSignUpJob.create(@referee.id, @referee.id)
  end
end
