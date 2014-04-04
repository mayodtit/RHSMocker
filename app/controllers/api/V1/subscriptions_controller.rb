class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self
  before_filter :create_credit_card!, only: :create
  before_filter :load_customer!

  def index
    @subscriptions = @customer.subscriptions.inject([]) do |array, subscription|
      array << {
        id: subscription.id,
        plan: StripeExtension.plan_serializer(subscription.plan)
      }
      array
    end

    index_resource(@subscriptions)
  end

  def create
    @customer.subscriptions.create(subscription_attributes)
    update_resource @user, user_attributes, name: :user
  end

  private

  def render_failure_if_not_self
    render_failure if (current_user.id != params[:user_id].to_i)
  end

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

  def load_customer!
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
    render_failure unless @customer
  end

  def subscription_attributes
    {plan: params.require(:subscription).require(:plan_id)}.tap do |attributes|
      attributes.merge!(trial_end: @user.subscription_end_date.to_i) if @user.subscription_end_date
    end
  end

  def user_attributes
    {
      is_premium: true,
      subscription_end_date: nil
    }
  end
end
