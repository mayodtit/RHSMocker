class Mails::ResetPasswordJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    url = Rails.application
               .routes
               .url_helpers
               .reset_password_users_url(user.reset_password_token)
    RHSMailer.reset_password_email(user.email, user.salutation, url).deliver
  end
end
