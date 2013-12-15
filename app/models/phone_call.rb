class PhoneCall < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'
  belongs_to :claimer, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :to_role, class_name: 'Role'

  has_one :message, :inverse_of => :phone_call
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id, :to_role, :to_role_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number, :claimer, :claimer_id, :claimed_at,
                  :ender, :ender_id, :ended_at, :identifier_token

  validates :user, :message, :destination_phone_number, :identifier_token, presence: true
  validates :identifier_token, uniqueness: true

  before_validation :generate_identifier_token

  # TODO - remove this fake job when nurseline is built
  after_create :schedule_phone_call_summary

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message

  def to_nurse?
    to_role.name.to_sym == :nurse
  end

  def to_pha?
    to_role.name.to_sym == :pha
  end

  private

  # 15-digit 0-padded unique random number
  def generate_identifier_token
    self.identifier_token ||= loop do
      token = ('%015i' % SecureRandom.random_number(10**15))
      break token unless self.class.find_by_identifier_token(token)
    end
  end

  def schedule_phone_call_summary
    PhoneCallSummaryJob.new.queue_summary(user.id, consult.id)
  end

  state_machine :initial => :unclaimed do
    event :claim do
      transition :unclaimed => :claimed
    end

    event :end do
      transition :claimed => :ended
    end

    event :reclaim do
      transition :ended => :claimed
    end

    event :unclaim do
      transition :claimed => :unclaimed
    end

    before_transition :unclaimed => :claimed do |phone_call, transition|
      phone_call.claimer = transition.args.first
      phone_call.claimed_at = Time.now
    end

    before_transition :claimed => :ended do |phone_call, transition|
      phone_call.ender = transition.args.first
      phone_call.ended_at = Time.now
    end

    before_transition :ended => :claimed do |phone_call, transition|
      phone_call.ender = nil
      phone_call.ended_at = nil
    end

    before_transition :claimed => :unclaimed do |phone_call, transition|
      phone_call.claimer = nil
      phone_call.claimed_at = nil
    end
  end
end
