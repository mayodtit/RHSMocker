class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  attr_accessible :user, :user_id, :plan, :plan_id, :stripe_id

  validates :user, :plan, presence: true
  validates :plan_id, uniqueness: {scope: :user_id}
  validate :stripe_ids_present

  after_create :subscribe_with_stripe!

  private

  def stripe_ids_present
    if user.stripe_customer_id.blank? || plan.stripe_id.blank?
      errors.add(:base, 'Error with payment provider, please try again later')
    end
  end

  def subscribe_with_stripe!
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    subscription = customer.subscriptions.create(plan: plan.stripe_id)
    update_attributes!(stripe_id: subscription.id)
  end
end
