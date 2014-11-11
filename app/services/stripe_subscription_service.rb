class StripeSubscriptionService
  def initialize(user, plan_id, credit_card_token=nil, trial_end=nil)
    @user = user
    @plan_id = plan_id
    @credit_card_token = credit_card_token
    @trial_end = trial_end
  end

  def create
    if @credit_card_token && @user.stripe_customer_id.nil?
      create_stripe_customer!
    elsif @credit_card_token
      create_stripe_credit_card!
    else
      load_stripe_customer!
    end

    create_stripe_subscription!
  end

  private

  def create_stripe_customer!
    @customer = Stripe::Customer.create(card: @credit_card_token,
                                        email: @user.email,
                                        description: StripeExtension.customer_description(@user.id))
    @user.update_attribute(:stripe_customer_id, @customer.id)
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

  def create_stripe_subscription!
    @customer.subscriptions.create(plan: @plan_id,
                                   trial_end: @trial_end.try(:to_i))
  end
end
