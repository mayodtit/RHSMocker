class Mails::ConfirmDiscountReceivedJob < Struct.new(:referrer_id, :referee_id)
  def self.create(referrer_id, referee_id)
    Delayed::Job.enqueue(new(referrer_id, referee_id))
  end

  def perform
    referrer = User.find(referrer_id)
    referee = User.find(referee_id)
    RHSMailer.confirm_discount_received(referrer, referee).deliver
  end
end
