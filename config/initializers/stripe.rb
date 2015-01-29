Stripe.api_key = ENV['STRIPE_API_KEY']

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE = 'OneTimeFiftyPercentOffCoupon'
ONE_TIME_HUNDRED_PERCENT_OFF_COUPON_CODE = "OneTimeHundredPercentOffCoupon"

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    Rails.logger.info("Received Stripe charge.failed, #{event.id} - #{event.type}")
    UserMailer.delay.notify_bosses_when_user_payment_fail(event)
    customer = Stripe::Customer.retrieve(event.data.object.customer)
    unless customer.delinquent
      user = User.find_by_stripe_customer_id(customer.id)
      RHSMailer.notify_user_when_first_charge_fail(event, user).deliver
    end
  end

  events.subscribe 'charge.succeeded' do |event|
    GrantReferrerCreditWhenRefereePay.new(event).assign_coupon
  end

  events.subscribe 'invoice.created' do |event|
    GrantReferrerCreditWhenRefereePay.new(event).apply_coupon
  end
end
