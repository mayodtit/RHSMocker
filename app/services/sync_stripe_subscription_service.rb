class SyncStripeSubscriptionService
  def initialize(event)
    @event = event
    @user = User.find_by_stripe_customer_id(event.data.object.customer)
  end

  def call
    return if @user.nil?
    event_type = @event.type
    if ( event_type == 'customer.subscription.created' ) || ( event_type == 'customer.subscription.updated' )
      create_subscription
    elsif event_type == 'customer.subscription.deleted'
      delete_subscription
    end
  end

  private

  def create_subscription
    @user.subscriptions.create( subscription_attributes )
    subscription = @user.subscriptions.last
    if @event.object.plan.amount > @event.previous_attributes.plan.amount
      subscription.update_attributes(:is_current => true)
    else
      subscription.delay.update_attributes(:is_current => true)
    end
  end

  def delete_subscription
    @user.subscriptions.last.update_attributes(:is_current => nil)
  end

  def subscription_attributes
    {
     start: @event.data.object.start,
     status: @event.data.object.status,
     customer: @event.data.object.customer,
     cancel_at_period_end: @event.data.object.cancel_at_period_end,
     current_period_start: @event.data.object.current_period_start,
     current_period_end: @event.data.object.current_period_end,
     ended_at: @event.data.object.ended_at,
     trial_start: @event.data.object.trial_start,
     trial_end: @event.data.object.trial_end,
     quantity: @event.data.object.quantity,
     application_fee_percent: @event.data.object.application_fee_percent,
     tax_percent: @event.data.object.tax_percent,
     discount: @event.data.object.discount,
     metadata: @event.data.object.metadata,
     user_id: @user.id,
     plan: @event.data.object.plan,
     stripe_subscription_id: @event.data.object.id
    }
  end
end
