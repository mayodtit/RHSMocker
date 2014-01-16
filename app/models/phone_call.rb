require './lib/utils/phone_number_util'
require 'twilio-ruby'

class PhoneCall < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'
  belongs_to :claimer, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :to_role, class_name: 'Role'

  # Outbound Calls
  belongs_to :dialer, class_name: 'Member'

  has_one :message, :inverse_of => :phone_call
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id, :to_role, :to_role_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number, :claimer, :claimer_id, :claimed_at,
                  :ender, :ender_id, :ended_at, :identifier_token,
                  :dialer_id, :dialer, :dialed_at

  validates :user, :message, :identifier_token, presence: true
  validates :identifier_token, uniqueness: true # Used for nurseline and creating unique conference calls
  validates :origin_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: true
  validates :destination_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: false

  before_validation :prep_phone_numbers
  before_validation :generate_identifier_token

  # TODO - remove this fake job when nurseline is built
  after_create :schedule_phone_call_summary
  after_create :dial_if_outbound

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message

  # A call can be inbound or outbound.
  def outbound?
    to_role.nil? && to_role_id.nil?
  end

  def to_nurse?
    to_role.name.to_sym == :nurse
  end

  def to_pha?
    to_role.name.to_sym == :pha
  end

  # Call mechanics

  # Create a singleton for Twilio client
  class << self
    @@twilio = Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN

    def twilio
      @@twilio
    end
  end

  def twilio
    self.class.twilio
  end

  def dial_if_outbound
    dial_origin if outbound?
  end

  def dial_origin
    call = twilio.account.calls.create(
      from: PhoneNumberUtil::format_for_dialing(TWILIO_CALLER_ID),
      to: PhoneNumberUtil::format_for_dialing(origin_phone_number),
      url: URL_HELPERS.connect_origin_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_origin_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )
  end

  def dial_destination
    call = twilio.account.calls.create(
      from: PhoneNumberUtil::format_for_dialing(TWILIO_CALLER_ID),
      to: PhoneNumberUtil::format_for_dialing(destination_phone_number),
      url: URL_HELPERS.connect_destination_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_destination_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )
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

  def prep_phone_numbers
    self.destination_phone_number = PhoneNumberUtil::prep_phone_number_for_db self.destination_phone_number
    self.origin_phone_number = PhoneNumberUtil::prep_phone_number_for_db self.origin_phone_number
  end

  state_machine :initial => lambda { |object| object.outbound? ? :dialing : :unclaimed } do
    event :claim do
      transition :unclaimed => :claimed
    end

    event :connect do
      transition [:dialing, :claimed] => :connected
    end

    event :disconnect do
      transition :connected => :disconnected
    end

    event :end do
      transition [:connected, :claimed] => :ended
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
