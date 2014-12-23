Stripe.api_key = ENV['STRIPE_API_KEY']

ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE = 'OneTimeFiftyPercentOffCoupon'

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    Rails.logger.info("Received Stripe charge.failed, #{event.id} - #{event.type}")
    UserMailer.delay.notify_bosses_when_user_payment_fail(event)
  end
end
