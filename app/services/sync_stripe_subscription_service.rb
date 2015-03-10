class SyncStripeSubscriptionService
  def initialize(event)
    @event = event
    @user = User.find_by_stripe_customer_id(event.data.object.customer)
  end

  def call
    return if @user.nil?
    event_type = @event.type
    if event_type == 'customer.subscription.created'
      create_subscription
    elsif event_type == 'customer.subscription.updated'
      update_subscription
    elsif event_type == 'customer.subscription.deleted'
      delete_subscription
    end
  end

  private

  def create_subscription
    @user.subscriptions.find_by_current(true).update_attributes(subscription_attributes)
  end

  def update_subscription
    latest_subscription = @user.subscriptions.last
    latest_subscription.update_attributes(subscription_attributes)
    #the downgrade senario, need to update the current param at end of period
    unless latest_subscription.current
      period_end = Time.at(@event.data.object.current_period_end).utc.to_datetime
      @user.subscriptions.find_by_current(true).delay(run_at: period_end).update_attributes(:current => false)
      latest_subscription.delay(run_at: period_end).update_attributes(:current => true)
    end
  end

  def delete_subscription
    @user.subscriptions.last.update_attributes(subscription_attributes.tap{|attribute|attribute.merge!(:current => false)})
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
     trial_end: @event.data.object.trial_end         ,
     quantity: @event.data.object.quantity,
     application_fee_percent: @event.data.object.application_fee_percent,
     tax_percent: @event.data.object.tax_percent,
     discount: @event.data.object.discount,
     metadata: @event.data.object.metadata,
     plan: @event.data.object.plan.to_hash,
     stripe_subscription_id: @event.data.object.id
    }
  end
end
