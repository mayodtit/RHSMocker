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

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    Rails.logger.info("Received Stripe charge.failed, #{event.id} - #{event.type}")
    UserMailer.delay.notify_bosses_when_user_payment_fail(event)
  end

  events.subscribe 'charge.succeeded' do |event|
    GrantReferrerCreditWhenRefereePay.new(event).assign_coupon
  end

  events.subscribe 'invoice.created' do |event|
    GrantReferrerCreditWhenRefereePay.new(event).apply_coupon
  end

  events.subscribe 'invoice.payment_succeeded' do |event|
    AdjustServiceLevelService.new(event).call
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    DowngradeMemberToFree.new(event).call
  end

  events.subscribe 'customer.subscription.trial_will_end' do |event|
    NotifyTrialWillEndService.new(event).call
  end
end
