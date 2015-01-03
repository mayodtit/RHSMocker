class GrantReferrerCreditWhenRefereePay
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
    unless referred?
      referrer.discount_records.create(user_id: referrer.id,
                                       referral_code_id: referral_code.id,
                                       coupoon: ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE,
                                       referrer: true)
    end
    @discount_record_id = referrer.discount_records.last.id
  end

  def referred?
    referred = false
    referrer.discount_records.each do |discount_record|
      if discount_record.referee_id == referee.id
        referred = true
        break
      end
    end
    referred
  end

  def redeem_coupon(referrer, customer)
    referrer_discount_record = referrer.discount_records.find(@discount_record_id)
    customer.coupon = referrer_discount_record.coupon
    customer.save
    rreferrer_discount_record.redeemed_at = Time.now
    referrer_discount_record.save!
  end
end
