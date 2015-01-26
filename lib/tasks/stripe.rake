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
