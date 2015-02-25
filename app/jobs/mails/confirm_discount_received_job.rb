class Mails::ConfirmDiscountReceivedJob < Struct.new(:referrer_id)
  def self.create(referrer_id)
    Delayed::Job.enqueue(new(referrer_id))
  end

  def perform
    referrer = User.find(referrer_id)
    RHSMailer.confirm_discount_received(referrer)
  end
end