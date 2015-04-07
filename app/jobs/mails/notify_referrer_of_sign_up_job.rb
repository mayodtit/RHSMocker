class Mails::NotifyReferrerOfSignUpJob < Struct.new(:referrer_id, :referee_id)
  def self.create(referrer_id, referee_id)
    Delayed::Job.enqueue(new(referrer_id, referee_id))
  end

  def perform
    referrer = Member.find(referrer_id)
    referee = Member.find(referee_id)
    RHSMailer.notify_referrer_of_sign_up(referrer, referee).deliver
  end
end
