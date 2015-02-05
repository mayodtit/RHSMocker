class CreateStripeSubscriptionService
  def initialize(options)
    @user = options[:user]
    @plan_id = options[:plan_id]
    @credit_card_token = options[:credit_card_token]
    @trial_end = options[:trial_end]
    @coupon_code = options[:coupon_code]
  end

  def call
    if @credit_card_token && @user.stripe_customer_id.nil?
      create_stripe_customer!
    elsif @credit_card_token
      create_stripe_credit_card!
    else
      load_stripe_customer!
    end
    add_referral_code_coupon!
    create_stripe_subscription!
  end

  private

  def create_stripe_customer!
    @customer = Stripe::Customer.create(card: @credit_card_token,
                                        email: @user.email,
                                        description: StripeExtension.customer_description(@user.id))
    @user.update_attribute(:stripe_customer_id, @customer.id)
    @customer.save
  end

  def create_stripe_credit_card!
    @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    @card = @customer.cards.create(card: @credit_card_token)
    @customer.default_card = @card.id
    @customer.save
  end

  def load_stripe_customer!
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
  end

  def add_referral_code_coupon!
    if @user.referral_code.try(:user_id)
      @customer.coupon = ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE
      @user.discounts.create(referral_code_id: @user.referral_code.id,
                             coupon: ONE_TIME_FIFTY_PERCENT_OFF_COUPON_CODE,
                             referrer: false)
      if @customer.save
        @user.discounts.last.update_attributes(redeemed_at: Time.now)
      end
    end
  end

  def create_stripe_subscription!
    @customer.subscriptions.create({ plan: @plan_id,
                                     trial_end: @trial_end.try(:to_i)})
    byebug
    subscription = Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.first
    Subscription.create(subscription_attributes(subscription)) if subscription
  end

  def subscription_attributes(subscription)
    {start: subscription.start,
     status: subscription.status,
     customer: subscription.customer,
     cancel_at_period_end: subscription.cancel_at_period_end,
     current_period_start: subscription.current_period_start,
     current_period_end: subscription.current_period_end,
     ended_at: subscription.ended_at,
     trial_start: subscription.trial_start,
     trial_end: subscription.trial_end,
     quantity: subscription.quantity,
     application_fee_percent: subscription.application_fee_percent,
     tax_percent: subscription.tax_percent,
     discount: subscription.discount,
     metadata: subscription.metadata,
     user_id: @user.id,
     plan_id: @plan_id}
  end
end
