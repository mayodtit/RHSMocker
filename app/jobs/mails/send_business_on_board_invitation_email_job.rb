class Mails::SendBusinessOnBoardInvitationEmailJob < Struct.new(:member_id, :link, :unique_on_boarding_user_token)
  def self.create(member_id, link, unique_on_boarding_user_token )
    Delayed::Job.enqueue(new(member_id, link, unique_on_boarding_user_token))
  end

  def perform
    member = Member.find(member_id)
    RHSMailer.business_on_board_invitation_email(member, link, unique_on_boarding_user_token)
  end
end