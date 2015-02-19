class Mails::ConfirmSubscriptionDeletionJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = User.find(user_id)
    RHSMailer.confirm_subscription_deletion(user).deliver
  end
end
