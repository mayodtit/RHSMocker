class GrantReferrerCreditWhenRefereePay
  def initialize(event)
    @event = event
  end

  def assign_coupon
    referee = find_member(find_stripe_customer_id(@event))
    return if referee.nil?
    referral_code = referee.referral_code
    referrer = referral_code.user if referral_code
    distribute_coupon(referrer, referee) if referrer
  end

  def apply_coupon
    referrer_stripe_customer = Stripe::Customer.retrieve(find_stripe_customer_id(@event))
    referrer = find_member(find_stripe_customer_id(@event))
    return if referrer.nil?
    if referrer && has_coupon?(referrer)
      if redeem_coupon(referrer, referrer_stripe_customer)
        RHSMailer.delay.confirm_discount_received(referrer)
      end
    end
  end

  private

  def has_coupon?(referrer)
    !referrer.discounts.where("discounts.redeemed_at IS NULL").nil?
  end

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
                                referrer: true)
    end
  end

  def used_referral_code?(referee, referrer)
    Discount.where(referral_code_id: referee.referral_code_id).each do |record|
      return true if record.user_id == referrer.id
    end
    false
  end

  def redeem_coupon(referrer, customer)
    referrer_discount_record = referrer.discounts.find_by_redeemed_at(nil)
    invoice_amount = @event.data.object.total
    invoice_id = @event.data.object.id
    discount_amount = invoice_amount * (referrer_discount_record.discount_percent)
    if referrer_discount_record
      if invoice_item = Stripe::InvoiceItem.create(:customer => customer,
                                                   :amount => discount_amount,
                                                   :currency => "usd",
                                                   :invoice => invoice_id,
                                                   :description => "Referral Discount")

      referrer_discount_record.update_attributes(invoice_item: invoice_item.to_hash)
      referrer_discount_record.redeemed_at = Time.now
      referrer_discount_record.save!
      end
    end
  end
end
