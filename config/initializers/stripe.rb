Stripe.api_key = ENV['STRIPE_API_KEY']

module Stripe
  def self.execute_request(opts)
    RestClient::Request.execute(opts.merge(ssl_version: :TLSv1))
  end
end

ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE = 'OneTimeFiftyPercentOffCoupon'
ONE_TIME_HUNDRED_PERCENT_OFF_COUPON_CODE = "OneTimeHundredPercentOffCoupon"

StripeEvent.event_retriever = lambda do |params|
  if params[:livemode]
    Stripe::Event.retrieve(params[:id])
  elsif (Rails.env.development? || Rails.env.qa?)
    Stripe::Event.construct_from(params.deep_symbolize_keys)
  else
    nil
  end
end
