class Mails::SendBusinessOnBoardInvitationEmailJob < Struct.new(:unique_on_boarding_user_token, :link)
  def self.create(unique_on_boarding_user_token, link )
    Delayed::Job.enqueue(new(unique_on_boarding_user_token, link))
  end

  def perform
    user = Member.find_by_unique_on_boarding_user_token(unique_on_boarding_user_token) ||
        Enrollment.find_by_unique_on_boarding_user_token(unique_on_boarding_user_token)
    RHSMailer.business_on_board_invitation_email(user, link).deliver
  end
end
