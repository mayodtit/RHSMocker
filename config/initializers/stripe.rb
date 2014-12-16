Stripe.api_key = ENV['STRIPE_API_KEY']

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

OneTimeFiftyPercentOffCoupon = 'OneTimeFiftyPercentOffCoupon'

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    Rails.logger.info("Received Stripe charge.failed, #{event.id} - #{event.type}")
    UserMailer.delay.notify_bosses_when_user_payment_fail(event)
  end

  events.subscribe 'change.succeeded' do |event|
    stripe_customer_id = event.data.object.card.customer
    referee = User.find(stripe_customer_id)
    referral_code ||= ReferralCode.find(referee.referral_code_id)
    referrer = User.find(referral_code.user_id) if referral_code && referral_code.user_id
    referrer.coupon_number += 1
    referee.referral_code_id = nil
  end

  events.subscribe 'invoice.created' do |event|
    stripe_customer_id = event.customer
    referrer_stripe_customer = Stripe::Customer.retrieve(stripe_customer_id)
    referrer = User.find(stripe_customer_id)
    if referrer.coupon_number != 0 && referrer_stripe_customer.discount.nil?
      referrer_stripe_customer.coupon = OneTimeFiftyPercentOffCoupon
      referrer.coupon_number -= 1
    end
  end
end
