class Mails::ScheduledPhoneCallMemberConfirmationJob < Struct.new(:scheduled_phone_call_id)
  def self.create(scheduled_phone_call_id)
    Delayed::Job.enqueue(new(scheduled_phone_call_id))
  end

  def perform
    RHSMailer.scheduled_phone_call_member_confirmation_email(scheduled_phone_call_id).deliver
  end
end
