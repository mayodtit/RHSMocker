class Mails::SendBusinessOnBoardInvitationEmailJob < Struct.new(:enrollment_id, :link, :uout)
  def self.create(enrollment_id, link, uout )
    Delayed::Job.enqueue(new(enrollment_id, link, uout))
  end

  def perform
    enrollment = Enrollment.find(enrollment_id)
    RHSMailer.business_on_board_invitation_email(enrollment, link, uout)
  end
end