namespace :stripe do
  task import_subscriptions: :environment do
    Member.where('stripe_customer_id IS NOT NULL').find_each do |m|
      stripe_customer = Stripe::Customer.retrieve(m.stripe_customer_id)
      stripe_subscriptions = stripe_customer.subscriptions

      # exit early for stripe error conditions
      if stripe_subscriptions.count > 1
        print 'S' + "user: #{m.id}"
        next
      elsif stripe_subscriptions.count < 1
        print '-' + "user: #{m.id}"
        next
      end

      stripe_subscription = stripe_subscriptions.first

      # check for existing subscription in our database
      if m.subscription.try(:stripe_subscription_id) == stripe_subscription.id
        print '*'
        next
      elsif m.subscription && m.subscription.stripe_subscription_id != stripe_subscription.id
        print '!' + "user: #{m.id}"
        next
      end

      subscription_attributes = {
                                  start: stripe_subscription.start,
                                  status: stripe_subscription.status,
                                  customer: stripe_subscription.customer,
                                  cancel_at_period_end: stripe_subscription.cancel_at_period_end,
                                  current_period_start: stripe_subscription.current_period_start,
                                  current_period_end: stripe_subscription.current_period_end,
                                  ended_at: stripe_subscription.ended_at,
                                  trial_start: stripe_subscription.trial_start,
                                  trial_end: stripe_subscription.trial_end,
                                  quantity: stripe_subscription.quantity,
                                  application_fee_percent: stripe_subscription.application_fee_percent,
                                  tax_percent: stripe_subscription.tax_percent,
                                  discount: stripe_subscription.discount,
                                  metadata: stripe_subscription.metadata,
                                  user_id: m.id,
                                  plan_id: stripe_subscription.plan.id,
                                  stripe_subscription_id: stripe_subscription.id
                                }

      Subscription.create(subscription_attributes)
      print '.'
    end
  end
end
