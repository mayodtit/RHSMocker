class GrantReferrerCreditWhenRefereePay
  def initialize(event)
    @event = event
  end

  def assign_coupon
    referee = find_member(find_stripe_customer_id(@event))
    referral_code = referee.referral_code
    referrer = referral_code.user if referral_code
    distribute_coupon(referrer, referee) if referrer
  end

  def apply_coupon
    referrer_stripe_customer = Stripe::Customer.retrieve(find_stripe_customer_id(@event))
    referrer = find_member(find_stripe_customer_id(@event))
    if referrer && has_coupon?(referrer)
      redeem_coupon(referrer, referrer_stripe_customer)
    end
  end

  private

  def has_coupon?(referrer)
    !referrer.discount_records.where("discount_records.redeemed_at IS NULL").nil?
  end

  def find_stripe_customer_id(event)
    event.data.object.customer
  end

  def find_member(stripe_customer_id)
    Member.find_by_stripe_customer_id(stripe_customer_id)
  end

  def distribute_coupon(referrer, referee)
    unless used_referral_code?(referee, referrer)
      referrer.discount_records.create(user_id: referrer.id,
                                       referral_code_id: referee.referral_code.id,
                                       coupon: ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE,
                                       referrer: true)
    end
  end

  def used_referral_code?(referee, referrer)
    DiscountRecord.where(referral_code_id = referee.referral_code_id).each do |record|
      return true if record.user_id == referrer.id
    end
    false
  end

  def redeem_coupon(referrer, customer)
    referrer_discount_record = referrer.discount_records.find_by_redeemed_at(nil)
    if referrer_discount_record
      customer.coupon = referrer_discount_record.coupon
      customer.save
      referrer_discount_record.redeemed_at = Time.now
      referrer_discount_record.save!
    end
  end
end
