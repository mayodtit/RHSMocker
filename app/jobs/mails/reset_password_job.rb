class Mails::ResetPasswordJob < Struct.new(:user_id, :url)
  def self.create(user_id, url)
    Delayed::Job.enqueue(new(user_id, url))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.reset_password_email(user.email, user.salutation, url).deliver
  end
end
