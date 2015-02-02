Stripe.api_key = ENV['STRIPE_API_KEY']

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE = 'OneTimeFiftyPercentOffCoupon'
ONE_TIME_HUNDRED_PERCENT_OFF_COUPON_CODE = "OneTimeHundredPercentOffCoupon"

StripeEvent.configure do |events|
  customer = Stripe::Customer.retrieve(event.data.object.customer)
  user = User.find_by_stripe_customer_id(customer.id)

  events.subscribe 'charge.failed' do |event|
    Rails.logger.info("Received Stripe charge.failed, #{event.id} - #{event.type}")
    UserMailer.delay.notify_bosses_when_user_payment_fail(event)
    SendChargeFailedNotification.new(event).call
  end

  events.subscribe 'charge.succeeded' do |event|
    user.delinquent = false
    GrantReferrerCreditWhenRefereePay.new(event).assign_coupon
  end

  events.subscribe 'invoice.created' do |event|
    GrantReferrerCreditWhenRefereePay.new(event).apply_coupon
  end
end
