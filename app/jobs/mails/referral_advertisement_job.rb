class Mails::ReferralAdvertisementJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.referral_advertisement_email(user).deliver
  end
end
