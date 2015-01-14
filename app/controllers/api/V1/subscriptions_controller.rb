class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self
  before_filter :create_credit_card!, only: :create
  before_filter :load_customer!, only: :create

  def index
    index_resource(@user.subscriptions)
  end

  # TODO: this transaction should be all-or-nothing.
  # Right now it's posible for the user to become premium without paying,
  # but it's better than them paying without becoming a premium member.
  def create
    sa = subscription_attributes # this needs to be assigned prior to the user's update_attributes

    if @user.update_attributes(user_attributes)
      @customer.subscriptions.create(sa)
      render_success(user: @user.serializer)
    else
      render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    if DestroyStripeSubscriptionService.new(@user, :upgrade).call
      render_success
    else
      render_failure({reason: 'Error occurred during subscription cancellation'}, 422)
    end
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
                                          description: StripeExtension.customer_description(@user.id))
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
      if @user.free_trial_ends_at && (@user.free_trial_ends_at.end_of_day > Time.zone.now.end_of_day)
        attributes.merge!(trial_end: @user.free_trial_ends_at.to_i) if @user.free_trial_ends_at
      end
      attributes.merge!(coupon: '50PERCENT') if @user.onboarding_group.try(:mayo_pilot?)
    end
  end

  def user_attributes
    {
      status_event: :upgrade,
      free_trial_ends_at: nil,
      subscription_ends_at: nil,
      actor_id: current_user.id
    }
  end
end
