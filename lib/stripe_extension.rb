class StripeExtension
  def self.plan_serializer(stripe_plan)
    {
      id: stripe_plan.id,
      name: stripe_plan.metadata[:display_name],
      price: stripe_plan.metadata[:display_price],

      # even though we're always returning nil, the iOS client is still reading in the description
      description: nil
    }
  end

  def self.customer_description(user_id)
    str = "User #{user_id}"
    str += " on #{Rails.env} (#{`hostname`.chomp})" unless Rails.env.production?
    str
  end
end