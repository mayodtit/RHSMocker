class NotifyReferrerWhenRefereeSignUpService
  def initialize(referral_code, member)
    @referrer = referral_code.creator
    @referee = member
  end

  def call
    Mails::NotifyReferrerOfSignUpJob.create(@referee.id, @referee.id) if @referrer
  end
end
