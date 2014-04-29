class Mails::InvitationJob < Struct.new(:user_id, :url)
  def self.create(user_id, url)
    Delayed::Job.enqueue(new(user_id, url))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.invitation_email(user, url).deliver
  end
end
