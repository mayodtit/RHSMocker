class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_subscription!, only: %i(show update destroy)
  before_filter :create_credit_card!, only: :create

  def index
    index_resource(@user.subscriptions.serializer)
  end

  def show
    show_resource(@subscription.serializer)
  end

  def create
    create_resource(@user.subscriptions, params[:subscription])
  end

  def update
    update_resource(@subscription, params[:subscription])
  end

  def destroy
    destroy_resource(@subscription)
  end

  private

  def load_subscription!
    @subscription = @user.subscriptions.find(params[:id])
    authorize! :manage, @subscription
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
end
