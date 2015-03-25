class Mails::SendBusinessOnBoardInvitationEmailJob < Struct.new(:user_id, :link, :unique_on_boarding_user_token)
  def self.create(user_id, link, unique_on_boarding_user_token )
    Delayed::Job.enqueue(new(user_id, link, unique_on_boarding_user_token))
  end

  def perform
    user = Member.find_by_id(user_id) || Enrollment.find_by_id(user_id)
    RHSMailer.business_on_board_invitation_email(user, link, unique_on_boarding_user_token)
  end
end
