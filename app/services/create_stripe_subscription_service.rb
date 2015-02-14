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
    add_referral_code_discount!
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

  def add_referral_code_discount!
    if @user.referral_code.try(:user_id)
      @user.discounts.create(referral_code_id: @user.referral_code.id,
                             coupon: 0.5,
                             referrer: false)
    end
  end

  def create_stripe_subscription!
    @customer.subscriptions.create(plan: @plan_id,
                                   trial_end: @trial_end.try(:to_i),
                                   coupon: @coupon_code)
  end
end
