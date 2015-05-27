class KinsightsSignupJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    KinsightsSignupService.new(member, member.kinsights_token).call
  end

  private

  def member
    Member.find(user_id)
  end
end
