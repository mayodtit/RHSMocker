class Mails::SendBusinessOnBoardInvitationEmailJob < Struct.new(:user_id, :link)
  def self.create(user_id, link )
    Delayed::Job.enqueue(new(user_id, link))
  end

  def perform
    user = Member.find_by_id(user_id) || Enrollment.find_by_id(user_id)
    RHSMailer.business_on_board_invitation_email(user, link).deliver
  end
end
