require 'socket'

class StripeExtension
  def self.plan_serializer(stripe_plan, user)
    if user.onboarding_group.try(:mayo_pilot?)
      price = stripe_plan[:metadata][:mayo_pilot_display_price] || "$#{stripe_plan[:price].to_f/100}/month"
    else
      price = stripe_plan[:metadata][:display_price] || "$#{stripe_plan[:price].to_f/100}/month"
    end

    {
      id: stripe_plan[:id],
      membership: stripe_plan[:metadata][:membership],
      name: stripe_plan[:metadata][:mayo_pilot_display_name] || stripe_plan[:name],
      price: price,
      image_url: stripe_plan[:metadata][:image_name],
      call_to_action_text: stripe_plan[:metadata][:call_to_action_text] || 'Continue',
      html_body: '<html></html>'
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
