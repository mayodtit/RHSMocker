class Mails::CustomWelcomeEmailJob < Struct.new(:user_id, :template)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.custom_welcome_email(user.email, template).deliver
  end
end
