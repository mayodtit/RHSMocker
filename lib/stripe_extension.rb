require 'socket'

class StripeExtension
  def self.plan_serializer(stripe_plan)
    {
      id: stripe_plan[:id],
      name: stripe_plan[:metadata][:display_name] || stripe_plan[:name],
      price: stripe_plan[:metadata][:display_price] || "$#{stripe_plan[:price].to_f/100}/month",

      # even though we're always returning nil, the iOS client is still reading in the description
      description: nil
    }
  end

  def self.subscription_serializer(stripe_subscription)
    {
      id: stripe_subscription[:id],
      plan: plan_serializer(stripe_subscription[:plan])
    }
  end

  def self.customer_description(user_id)
    str = "User #{user_id}"
    str += " on #{Rails.env} (#{Socket.gethostname})" unless Rails.env.production?
    str
  end

  def self.subscriber_emails(limit = 100)
    puts "Note: this only lists the first 100 customers.  Pagination magic required if/when we have more than that"
    Stripe::Customer.all(limit: limit).map{|c| c.email if c.subscriptions.count != 0}.compact
  end
end
