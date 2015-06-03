class Mails::CustomWelcomeEmailJob < Struct.new(:user_id, :template)
  def self.create(user_id, template)
    Delayed::Job.enqueue(new(user_id, template))
  end

  def perform
    RHSMailer.custom_welcome_email(user_id, template).deliver
  end
end
