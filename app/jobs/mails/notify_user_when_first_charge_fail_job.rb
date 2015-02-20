class Mails::NotifyUserWhenFirstChargeFailJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = User.find(user_id)
    RHSMailer.notify_user_when_first_charge_fail(user)
  end
end
