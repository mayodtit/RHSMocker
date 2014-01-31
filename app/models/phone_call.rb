require 'twilio-ruby'

class PhoneCall < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'
  belongs_to :claimer, class_name: 'Member'
  belongs_to :dialer, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :resolver, class_name: 'Member'
  belongs_to :transferrer, class_name: 'Member'
  belongs_to :to_role, class_name: 'Role'
  belongs_to :transferred_to_phone_call, class_name: 'PhoneCall'

  has_one :message, :inverse_of => :phone_call
  has_one :scheduled_phone_call
  has_one :transferred_from_phone_call, class_name: 'PhoneCall', foreign_key: :transferred_to_phone_call_id

  attr_accessible :user, :user_id, :to_role, :to_role_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number, :claimer, :claimer_id, :ender, :ender_id,
                  :identifier_token, :dialer_id, :dialer, :state_event, :destination_twilio_sid,
                  :origin_twilio_sid, :transferrer_id, :transferrer, :transferred_to_phone_call,
                  :transferred_to_phone_call_id, :twilio_conference_name

  validates :twilio_conference_name, :identifier_token, presence: true
  validates :identifier_token, uniqueness: true # Used for nurseline and creating unique conference calls
  validates :origin_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: true
  validates :destination_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: false
  validate :attrs_for_states

  before_validation :prep_phone_numbers
  before_validation :generate_identifier_token

  after_create :dial_if_outbound

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

  def self.accepting_calls_to_pha?
    t = Time.now.in_time_zone('Pacific Time (US & Canada)')

    return !(t.wday == 0 || t.wday == 6 || t.hour < 9 || t.hour > 17)
  end

  def initial_state
    return :dialing if outbound?
    return :unresolved if to_role && to_role.name.to_sym != :nurse
    :unclaimed
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
      from: PhoneNumberUtil::format_for_dialing(PHA_NUMBER),
      to: PhoneNumberUtil::format_for_dialing(origin_phone_number),
      url: URL_HELPERS.connect_origin_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_origin_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )

    self.origin_twilio_sid = call.sid
    save!
  end

  def dial_destination
    call = twilio.account.calls.create(
      from: PhoneNumberUtil::format_for_dialing(PHA_NUMBER),
      to: PhoneNumberUtil::format_for_dialing(destination_phone_number),
      url: URL_HELPERS.connect_destination_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_destination_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )

    self.destination_twilio_sid = call.sid
    save!
  end

  def self.resolve(phone_number, origin_twilio_sid)
    phone_number = PhoneNumberUtil.prep_phone_number_for_db phone_number

    if PhoneNumberUtil::is_valid_caller_id phone_number
      if phone_call = PhoneCall.where(state: :unresolved, origin_phone_number: phone_number).first(order: 'id desc', limit: 1)
        phone_call.update_attributes state_event: :resolve, origin_twilio_sid: origin_twilio_sid
        return phone_call
      end

      if member = Member.find_by_phone(phone_number)
        return PhoneCall.create(
          user: member,
          origin_phone_number: phone_number,
          destination_phone_number: PHA_NUMBER,
          to_role: Role.find_by_name!(:pha),
          state_event: :resolve,
          origin_twilio_sid: origin_twilio_sid
        )
      end
    else
      phone_number = nil
    end

    PhoneCall.create(
      origin_phone_number: phone_number,
      destination_phone_number: PHA_NUMBER,
      to_role: Role.find_by_name!(:pha),
      state_event: :resolve,
      origin_twilio_sid: origin_twilio_sid
    )
  end

  private

  # 15-digit 0-padded unique random number
  def generate_identifier_token
    self.identifier_token ||= loop do
      token = ('%015i' % SecureRandom.random_number(10**15))
      break token unless self.class.find_by_identifier_token(token)
    end

    self.twilio_conference_name ||= identifier_token
  end

  def prep_phone_numbers
    if self.destination_phone_number_changed?
      self.destination_phone_number = PhoneNumberUtil::prep_phone_number_for_db self.destination_phone_number
    end

    if self.origin_phone_number_changed?
      self.origin_phone_number = PhoneNumberUtil::prep_phone_number_for_db self.origin_phone_number
    end
  end

  state_machine :initial => lambda { |object| object.initial_state } do
    event :claim do
      transition :unclaimed => :claimed
    end

    event :resolve do
      transition :unresolved => :unclaimed
    end

    event :miss do
      transition :unclaimed => :missed
    end

    event :dial do
      transition [:dialing, :claimed, :disconnected] => :dialing
    end

    event :connect do
      transition :dialing => :connected
    end

    event :disconnect do
      transition :connected => :disconnected
    end

    event :transfer do
      transition [:unclaimed, :connected] => :transferred
    end

    event :end do
      transition [:disconnected, :connected, :claimed] => :ended
    end

    event :reclaim do
      transition :ended => :claimed
    end

    event :unclaim do
      transition :claimed => :unclaimed
    end

    before_transition :unresolved => any do |phone_call|
      phone_call.resolved_at = Time.now
    end

    before_transition :unclaimed => :missed do |phone_call|
      phone_call.missed_at = Time.now
    end

    before_transition :unclaimed => :claimed do |phone_call|
      phone_call.claimed_at = Time.now
    end

    before_transition [:dialing, :claimed, :disconnected] => :dialing do |phone_call|
      raise "Dialer is missing on PhoneCall #{phone_call.id}" if phone_call.dialer.nil?
      raise "Dialer is missing work phone number on PhoneCall #{phone_call.id}" if !phone_call.dialer.work_phone_number
      phone_call.destination_phone_number = phone_call.dialer.work_phone_number
    end

    after_transition [:dialing, :claimed, :disconnected] => :dialing do |phone_call|
      phone_call.dial_destination
    end

    before_transition any => :transferred do |phone_call|
      nurseline_phone_call = PhoneCall.create!(
        user: phone_call.user,
        origin_phone_number: phone_call.origin_phone_number,
        destination_phone_number: NURSELINE_NUMBER,
        to_role: Role.find_by_name!(:nurse),
        origin_twilio_sid: phone_call.origin_twilio_sid,
        twilio_conference_name: phone_call.twilio_conference_name
      )

      phone_call.transferred_to_phone_call = nurseline_phone_call
      phone_call.transferred_at = Time.now
    end

    after_transition any => :transferred do |phone_call|
      phone_call.transferred_to_phone_call.dial_destination
    end

    before_transition any => :ended do |phone_call|
      phone_call.ended_at = Time.now
    end

    before_transition :ended => :claimed do |phone_call|
      phone_call.ender = nil
      phone_call.ended_at = nil
      phone_call.claimed_at = Time.now
    end

    before_transition :claimed => :unclaimed do |phone_call|
      phone_call.claimer = nil
      phone_call.claimed_at = nil
    end
  end

  # TODO: Write more comprehensive tests
  def attrs_for_states
    state_sym = state.to_sym

    case state_sym
      when :claimed
        validate_actor_and_timestamp_exist :claim
      when :missed
        validate_timestamp_exists :miss
      when :transferred
        validate_actor_and_timestamp_exist :transfer
        if transferred_to_phone_call_id.nil?
          errors.add(:transferred_to_phone_call_id, "must be present when #{self.class.name} is #{state}")
        end
      when :ended
        validate_actor_and_timestamp_exist :end
    end
  end
end
