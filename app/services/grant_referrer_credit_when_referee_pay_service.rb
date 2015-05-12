class GrantReferrerCreditWhenRefereePayService
  def initialize(event)
    @event = event
  end

  def call
    referee = find_member(find_stripe_customer_id(@event))
    return if referee.nil?
    referral_code = referee.referral_code
    referrer = referral_code.user if referral_code
    distribute_coupon(referrer, referee) if referrer
  end

  private

  def find_stripe_customer_id(event)
    event.data.object.customer
  end

  def find_member(stripe_customer_id)
    Member.find_by_stripe_customer_id(stripe_customer_id)
  end

  def distribute_coupon(referrer, referee)
    unless used_referral_code?(referee, referrer)
      referrer.discounts.create(referral_code_id: referee.referral_code.id,
                                discount_percent: 1.0,
                                referee_id: referee.id,
                                referrer: true)
    end
  end

  def used_referral_code?(referee, referrer)
    Discount.where(referral_code_id: referee.referral_code_id).each do |record|
      return true if record.user_id == referrer.id
    end
    false
  end
end
