class Mails::MayoPilotInviteJob < Struct.new(:user_id, :provider_id)
  def self.create(user_id, provider_id)
    Delayed::Job.enqueue(new(user_id, provider_id))
  end

  def perform
    user = Member.find(user_id)
    provider = User.find(provider_id)
    RHSMailer.mayo_pilot_invite_email(user, provider).deliver
  end
end
