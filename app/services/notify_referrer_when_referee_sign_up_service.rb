class NotifyReferrerWhenRefereeSignUpService
  def initialize(referral_code, member)
    @referrer = referral_code.user
    @referee = member
  end

  def call
    Mails::NotifyReferrerOfSignUpJob.create(@referrer.id, @referee.id) if @referrer
  end
end
