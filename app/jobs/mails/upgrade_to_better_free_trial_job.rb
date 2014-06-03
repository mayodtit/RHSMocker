class Mails::UpgradeToBetterFreeTrialJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.upgrade_to_better_free_trial_email(user.email, user.salutation).deliver
  end
end
