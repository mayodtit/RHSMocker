class Mails::ConfirmSubscriptionChangeJob < Struct.new(:user_id, :subscription)
  def self.create(user_id, subscription)
    Delayed::Job.enqueue(new(user_id, subscription))
  end

  def perform
    user = User.find(user_id)
    RHSMailer.confirm_subscription_change(user, subscription).deliver
  end
end