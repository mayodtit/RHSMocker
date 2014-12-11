Stripe.api_key = ENV['STRIPE_API_KEY']

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE = 'OneTimeFiftyPercentOffCoupon'
