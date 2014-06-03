class Mails::WelcomeToPremiumJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.welcome_to_premium_email(user.email, user.salutation).deliver
  end
end
