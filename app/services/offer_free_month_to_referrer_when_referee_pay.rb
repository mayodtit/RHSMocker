class OfferFreeMonthToReferrerWhenRefereePay
  def initialize(event)
    @event = event
  end

  def assign_coupon
    referee = find_member(find_stripe_customer_id(@event))
    referral_code = referee.referral_code
    referrer = referral_code.user
    distribute_coupon(referrer, referee) if referrer
  end

  def apply_coupon
    referrer_stripe_customer = Stripe::Customer.retrieve(find_stripe_customer_id(@event))
    referrer = find_member(find_stripe_customer_id(@event))
    if referrer && referrer.coupon_count > 0 && referrer_stripe_customer.discount.nil?
      redeem_coupon(referrer, referrer_stripe_customer)
    end
  end

  private

  def find_stripe_customer_id(event)
    event.data.object.customer
  end

  def find_member(stripe_customer_id)
    Member.find_by_stripe_customer_id(stripe_customer_id)
  end

  def distribute_coupon(referrer, referee)
    referee.referral_code_id = nil
    referee.save!
    referrer.increment!(:coupon_count)
    referrer.save!
  end

  def redeem_coupon(referrer, customer)
    customer.coupon = ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE
    customer.save
    referrer.decrement!(:coupon_count)
    referrer.save!
  end
end
