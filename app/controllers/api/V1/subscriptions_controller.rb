class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self
  before_filter :create_credit_card!, only: :create

  # assumptions
  # - user may or may not already have a stripe customer id
  # - user DOES NOT have a credit card on file
  def create
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)

    hash = {plan: params[:subscription]}
    hash.merge!({trial_end: @user.subscription_end_date.to_i}) unless @user.subscription_end_date.nil?
    customer.subscriptions.create(hash)
    @user.update_attribute(:subscription_end_date, nil)

    render_success
  end

  private

  def create_credit_card!
    return unless params[:stripe_token]
    if @user.stripe_customer_id.nil?
      @customer = Stripe::Customer.create(card: params[:stripe_token],
                                          email: @user.email,
                                          description: @user.email)
      @user.update_attribute(:stripe_customer_id, @customer.id)
    else
      @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      @card = @customer.cards.create(card: params[:stripe_token])
      @customer.default_card = @card.id
      @customer.save
    end
  end

  def render_failure_if_not_self
    render_failure if (current_user.id != params[:user_id].to_i)
  end
end
