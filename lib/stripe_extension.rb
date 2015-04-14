require 'socket'

class StripeExtension
  def self.plan_serializer(stripe_plan, user=nil)
    if user.try(:onboarding_group).try(:mayo_pilot?)
      price = stripe_plan[:metadata][:mayo_pilot_display_price] || "$#{stripe_plan[:price].to_f/100}/month"
    elsif birthday_sale? && yearly_plan?(stripe_plan)
      price = stripe_plan[:metadata][:birthday_display_price] || "$#{stripe_plan[:price].to_f/100}/month"
    else
      price = stripe_plan[:metadata][:display_price] || "$#{stripe_plan[:price].to_f/100}/month"
    end

    {
      id: stripe_plan[:id],
      membership: stripe_plan[:metadata][:membership],
      name: stripe_plan[:metadata][:display_name] || stripe_plan[:name],
      price: price,
      image_url: stripe_plan[:metadata][:image_name],
      call_to_action_text: stripe_plan[:metadata][:call_to_action_text] || 'Continue',
      html_body: '<html></html>'
    }
  end

  def self.subscription_serializer(stripe_subscription)
    {
      id: stripe_subscription[:id],
      plan: plan_serializer(stripe_subscription[:plan]),
      cancel_at_period_end: stripe_subscription[:cancel_at_period_end],
      current_period_end: stripe_subscription[:current_period_end]
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

  def self.birthday_sale?
    Time.now > Time.parse('2015-04-13 00:00:00 -0700') && Time.now < Time.parse('2015-05-02 00:00:00 -0700')
  end

  def self.yearly_plan?(plan)
    'bpYRSingle192' == plan[:id] || 'bpYRFamily480' == plan[:id]
  end
end
