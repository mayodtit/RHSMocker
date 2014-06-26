class ReferralCardJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id), run_at: 5.days.from_now)
  end

  def perform
    user = Member.find(user_id)
    user.cards.create(resource: CustomCard.referral) if CustomCard.referral
  end
end
