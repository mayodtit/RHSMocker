class Mails::MeetYourPhaJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.meet_your_pha_email(user.email).deliver
  end
end
