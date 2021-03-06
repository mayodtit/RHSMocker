class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self
  before_filter :create_credit_card!, only: :create
  before_filter :load_customer!, only: :create

  def index
    index_resource(@user.subscription)
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        sa = subscription_attributes
        raise "can't have more than one subscription" if (@customer.subscriptions.count > 0)
        subscription = @customer.subscriptions.create(sa)
        if @user.update_attributes(user_attributes)
          render_success({user: @user.serializer,
                          subscription: Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.first})
          Mails::ConfirmSubscriptionChangeJob.create(@user.id, subscription)
          RedeemDiscountService.new(status: :first, customer: @customer, member: @user, plan: Stripe::Plan.retrieve(sa[:plan])).call
        else
          render_failure({reason: 'Error occurred while adding subscription',
                          user_message: 'Error occurred while adding subscription'}, 422)
        end
      end
    rescue Stripe::CardError => e
      Rails.logger.error "Error in subscriptionsController#create for user #{@user.id}: #{e}"
      #render the e.as_json['code'] for reason when client ready to upgrade user version
      render_failure({reason: e.as_json['message'],
                      user_message: e.as_json['message']}, 422) and return
    rescue => e
      Rails.logger.error "Error in subscriptionsController#create for user #{@user.id}: #{e}"
      #render the e.to_s for reason when client ready to upgrade user version
      render_failure({reason: 'Error occurred while adding subscription',
                      user_message: 'Error occurred while adding subscription'}, 422) and return
    end
  end

  def destroy
    if DestroyStripeSubscriptionService.new(@user, :downgrade).call
      render_success
    else
      render_failure({reason: 'Error occurred during subscription cancellation'}, 422)
    end
  end

  def update
    begin
      if UpdateStripeSubscriptionService.new(@user, subscription_attributes[:plan], available_coupon).call
        render_success ({ subscription: Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.first })
      else
        render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
      end
    rescue Stripe::CardError => e
      Rails.logger.error "Error in subscriptionsController#update for user #{@user.id}: #{e}"
      #render the e.as_json['code'] for reason when client ready to upgrade user version
      render_failure({reason: e.as_json['message'],
                      user_message: e.as_json['message']}, 422) and return
    rescue => e
      Rails.logger.error "Error in subscriptionsController#update for user #{@user.id}: #{e}"
      #render the e.to_s for reason when client ready to upgrade user version
      render_failure({reason: 'Error occurred while updating subscription',
                      user_message: 'Error occurred while updating subscription'}, 422) and return
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
    {plan: plan_id}.tap do |attributes|
      if @user.free_trial_ends_at && (@user.free_trial_ends_at.end_of_day > Time.zone.now.end_of_day)
        attributes.merge!(trial_end: @user.free_trial_ends_at.to_i) if @user.free_trial_ends_at
      elsif @user.new_user?
        attributes.merge!(trial_end: 1.month.from_now.pacific.end_of_day.to_i)
      end

      attributes.merge!(coupon: available_coupon) if available_coupon
    end
  end

  def plan_id
    params.require(:subscription).require(:plan_id)
  end

  def user_attributes
    {
      status_event: :upgrade,
      free_trial_ends_at: nil,
      subscription_ends_at: nil,
      actor_id: current_user.id
    }
  end

  def available_coupon
    if @user.onboarding_group.try(:mayo_pilot?)
      '50PERCENT'
    end
  end
end
