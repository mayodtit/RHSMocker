namespace :stripe do
  task import_subscriptions: :environment do
    Member.where('stripe_customer_id IS NOT NULL').find_each do |m|
      stripe_customer = Stripe::Customer.retrieve(m.stripe_customer_id)
      stripe_subscriptions = stripe_customer.subscriptions

      # exit early for stripe error conditions
      if stripe_subscriptions.count > 1
        print 'S'
        next
      elsif stripe_subscriptions.count < 1
        print '-'
        next
      end

      stripe_subscription = stripe_subscriptions.first

      # check for existing subscription in our database
      if m.subscription.try(:stripe_subscription_id) == stripe_subscription_id
        print '*'
        next
      elsif m.subscription && m.subscription.stripe_subscription_id != stripe_subscription.id
        print '!'
        next
      end

      m.create_subscription!(stripe_subscription_id: stripe_subscription.id)
      print '.'
    end
  end
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
      plan_id: @event.data.object.plan.id
  }
end