require 'twilio-ruby'

class PhoneCall < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  CONNECTED_STATUS = 'in-progress' # Twilio calls it in-progress

  belongs_to :user, class_name: 'Member'
  belongs_to :creator, class_name: 'Member'
  belongs_to :claimer, class_name: 'Member'
  belongs_to :dialer, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :resolver, class_name: 'Member'
  belongs_to :to_role, class_name: 'Role'
  belongs_to :transferred_to_phone_call, class_name: 'PhoneCall'
  belongs_to :merged_into_phone_call, class_name: 'PhoneCall'

  has_one :message, :inverse_of => :phone_call
  has_one :consult, through: :message
  has_one :scheduled_phone_call
  has_one :transferred_from_phone_call, class_name: 'PhoneCall', foreign_key: :transferred_to_phone_call_id
  has_one :phone_call_task, inverse_of: :phone_call

  attr_accessible :user, :user_id, :to_role, :to_role_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number, :claimer, :claimer_id, :ender, :ender_id,
                  :identifier_token, :dialer_id, :dialer, :state_event, :destination_twilio_sid,
                  :origin_twilio_sid, :twilio_conference_name, :origin_status, :destination_status,
                  :outbound, :merged_into_phone_call, :merged_into_phone_call_id, :creator, :creator_id

  validates :twilio_conference_name, :identifier_token, :creator, presence: true
  validates :identifier_token, uniqueness: true # Used for nurseline and creating unique conference calls
  validates :origin_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: true
  validates :destination_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: false
  validates :to_role_id, presence: true, if: lambda {|p| !p.outbound? }
  validates :to_role, presence: true, if: lambda {|p| p.to_role_id }
  validates :merged_into_phone_call, presence: true, if: lambda {|p| p.merged_into_phone_call_id.present? }
  validate :attrs_for_states

  before_validation :set_to_role, on: :create
  before_validation :prep_phone_numbers
  before_validation :generate_identifier_token
  before_validation :transition_state
  before_validation :set_member_phone_number
  before_validation :set_creator, on: :create

  after_create :dial_if_outbound
  after_commit :publish
  after_save :create_task
  after_save :create_message_if_user_updated
  after_save :set_user_phone
  after_save :set_member_on_task

  # for metrics
  scope :to_nurse_line, -> { where(destination_phone_number: PhoneCall.nurseline_numbers) }
  scope :valid_call, -> { where('TIMESTAMPDIFF(SECOND, claimed_at, ended_at) > 60') } # filter out calls shorter than 1 minute
  scope :valid_nurse_call, -> { to_nurse_line.valid_call }

  def self.nurseline_numbers
    [8553270607, 8553270608]
  end

  def origin_connected?
    origin_status == CONNECTED_STATUS
  end

  def destination_connected?
    destination_status == CONNECTED_STATUS
  end

  def cp_connected?
    (outbound? && origin_connected?) || (!outbound? && destination_connected?)
  end

  def member_connected?
    (outbound? && destination_connected?) || (!outbound? && origin_connected?)
  end

  def to_nurse?
    to_role && to_role.name.to_sym == :nurse
  end

  def to_pha?
    to_role && to_role.name.to_sym == :pha
  end

  def in_progress?
    %w(unresolved unclaimed claimed dialing connected disconnected).include? state.to_s
  end

  def initial_state
    return :dialing if outbound?
    return :unclaimed if to_role && to_role.name.to_sym == :nurse
    :unresolved
  end

  def set_to_role
    self.to_role_id = Role.find_by_name!(:pha).id if to_role_id.nil? && !outbound?
  end

  # Call mechanics
  def dial_if_outbound
    dial_origin if outbound?
  end

  def dial_origin(dialer = nil)
    call = TwilioModule.client.account.calls.create(
      from: PhoneNumberUtil::format_for_dialing(Metadata.pha_phone_number),
      to: PhoneNumberUtil::format_for_dialing(origin_phone_number),
      url: URL_HELPERS.connect_origin_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_origin_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )

    self.update_attributes!(state_event: :dial, origin_twilio_sid: call.sid, dialer: dialer || self.dialer)
  end

  def dial_destination(dialer = nil)
    call = TwilioModule.client.account.calls.create(
      from: PhoneNumberUtil::format_for_dialing(Metadata.pha_phone_number),
      to: PhoneNumberUtil::format_for_dialing(destination_phone_number),
      url: URL_HELPERS.connect_destination_api_v1_phone_call_url(self),
      method: 'POST',
      status_callback: URL_HELPERS.status_destination_api_v1_phone_call_url(self),
      status_callback_method: 'POST'
    )

    unless to_role && to_role.name == 'nurse'
      self.update_attributes!(state_event: :dial, destination_twilio_sid: call.sid, dialer: dialer || self.dialer)
    end
  end

  def self.resolve(phone_number, origin_twilio_sid, role = Role.pha)
    phone_number = PhoneNumberUtil.prep_phone_number_for_db phone_number
    state_event = role.name == 'pha' ? :resolve : nil

    if PhoneNumberUtil::is_valid_caller_id phone_number
      phone_call = PhoneCall.where(
        state: role.name == 'pha' ? :unresolved : :unclaimed,
        origin_phone_number: phone_number,
        to_role_id: role.id
      ).first(order: 'id desc', limit: 1)

      if phone_call && (Time.now - phone_call.created_at) <= 5.minutes
        phone_call.update_attributes state_event: state_event, origin_twilio_sid: origin_twilio_sid, origin_status: CONNECTED_STATUS
        return phone_call
      end

      if member = Member.find_by_phone(phone_number)
        phone_call = PhoneCall.create(
          user: member,
          origin_phone_number: phone_number,
          destination_phone_number: role.name == 'pha' ? Metadata.pha_phone_number : Metadata.nurse_phone_number,
          state_event: state_event,
          origin_twilio_sid: origin_twilio_sid,
          origin_status: CONNECTED_STATUS,
          to_role: role,
          creator: member
        )

        if member.master_consult
          Message.create(
            user: member,
            consult: member.master_consult,
            phone_call_id: phone_call.id
          )
        end

        return phone_call
      end
    else
      phone_number = nil
    end

    if role.name == 'pha'
      PhoneCall.create(
        origin_phone_number: phone_number,
        destination_phone_number: Metadata.pha_phone_number,
        to_role: Role.find_by_name!(:pha),
        state_event: state_event,
        origin_twilio_sid: origin_twilio_sid,
        origin_status: CONNECTED_STATUS,
        creator: Member.robot
      )
    end
  end

  def hang_up
    if origin_twilio_sid.present? && (outbound? || !transferred?)
      call = TwilioModule.client.account.calls.get origin_twilio_sid
      call.update status: 'completed'
    end
    if destination_twilio_sid.present? && (!outbound? || !transferred?)
      call = TwilioModule.client.account.calls.get destination_twilio_sid
      call.update status: 'completed'
    end
  end

  def transferred?
    transferred_to_phone_call_id.present?
  end

  def transfer! transferrer
    nurseline_phone_call = PhoneCall.create!(
      user: user,
      origin_phone_number: origin_phone_number,
      destination_phone_number: Metadata.nurse_phone_number,
      to_role: Role.find_by_name!(:nurse),
      origin_twilio_sid: origin_twilio_sid,
      twilio_conference_name: twilio_conference_name,
      origin_status: origin_status,
      creator: transferrer
    )

    # Create a message so it shows up in the user's timeline
    if user && user.master_consult
      Message.create!(
        user: user,
        consult: user.master_consult,
        phone_call_id: nurseline_phone_call.id,
        content_id: message && message.content_id,
        symptom_id: message && message.symptom_id,
        condition_id: message && message.condition_id
      )
    end

    self.transferred_to_phone_call = nurseline_phone_call
    save!
    transferred_to_phone_call.dial_destination
  end

  def merge_attributes!(phone_call)
    attrs = phone_call.attributes.select do |attr, value|
      !%w(id merged_into_phone_call_id state resolved_at identifier_token twilio_conference_name).include?(attr.to_s) && value.present? && PhoneCall.column_names.include?(attr.to_s)
    end

    assign_attributes attrs, without_protection: true
    save!
  end

  def publish
    unless id_changed?
      PubSub.publish "/phone_calls/#{id}/update", { id: id }

      if user_id_changed? && phone_call_task
        phone_call_task.publish
      end
    end
  end

  def create_task
    return if outbound?

    if id_changed? # New record
      if unclaimed?
        PhoneCallTask.create_if_only_opened_for_phone_call! self
      end
    end
  end

  def set_member_phone_number
    return if outbound?

    if origin_phone_number.nil? && user && user.phone.present?
      self.origin_phone_number = user.phone
    end
  end

  # Handles case where unknown caller is identified by PHA
  def create_message_if_user_updated
    if !message && !id_changed? && user_id_changed? && user && user.master_consult && (!outbound? || user.phone == destination_phone_number)
      Message.create!(
        user: user,
        consult: user.master_consult,
        phone_call_id: id
      )
    end
  end

  def set_user_phone
    if user && user.phone.nil?
      if outbound? && destination_phone_number
        user.update_attributes! phone: destination_phone_number
      elsif !outbound? && origin_phone_number
        user.update_attributes! phone: origin_phone_number
      end
    end
  end

  private

  # 15-digit 0-padded unique random number
  def generate_identifier_token
    self.identifier_token ||= loop do
      token = ('%015i' % random_number)
      break token unless self.class.find_by_identifier_token(token)
    end

    self.twilio_conference_name ||= identifier_token
  end

  def random_number
    SecureRandom.random_number(10**15)
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
    event :resolve do
      transition :unresolved => :unclaimed
    end

    event :merge do
      transition :unresolved => :merged
    end

    event :claim do
      transition [:ended, :unclaimed, :disconnected] => :claimed
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
      transition(
        [:missed, :unclaimed] => :missed,
        [:claimed, :dialing, :connected, :disconnected] => :disconnected,
        :ended => :ended
      )
    end

    event :end do
      transition any => :ended
    end

    event :unclaim do
      transition [:disconnected, :claimed] => :unclaimed
    end

    before_transition :unresolved => any do |phone_call|
      phone_call.resolved_at = Time.now
    end

    before_transition :unresolved => :merged do |phone_call|
      phone_call.merged_into_phone_call.merge_attributes! phone_call
    end

    after_transition :unresolved => :merged do |phone_call|
      phone_call.message.update_attributes! phone_call_id: phone_call.merged_into_phone_call_id
    end

    after_transition :unresolved => :unclaimed do |phone_call|
      PhoneCallTask.create_if_only_opened_for_phone_call! phone_call
    end

    before_transition [:disconnected, :unclaimed] => :missed do |phone_call|
      phone_call.missed_at = Time.now
    end

    before_transition :unclaimed => :claimed do |phone_call|
      phone_call.claimed_at = Time.now
    end

    before_transition [:claimed, :disconnected] => :dialing do |phone_call|
      raise "Dialer is missing on PhoneCall #{phone_call.id}" if phone_call.dialer.nil?
      raise "Dialer is missing work phone number on PhoneCall #{phone_call.id}" if !phone_call.dialer.work_phone_number
      phone_call.destination_phone_number = phone_call.dialer.work_phone_number
    end

    after_transition [:claimed, :disconnected] => :dialing do |phone_call|
      if phone_call.destination_connected?
        phone_call.dial_origin
      else
        phone_call.dial_destination
      end
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

    after_transition any - :missed => :missed do |phone_call, transition|
      if task = phone_call.phone_call_task
        task.update_attributes! state_event: :abandon, reason: transition.args.first || 'missed', abandoner: Member.robot
      end

      # TODO: Add follow up task
    end
  end

  def transition_state
    if state == 'connected' && !(origin_connected? && destination_connected?)
      disconnect
    elsif (state == 'disconnected' || state == 'dialing') && origin_connected? && destination_connected?
      connect
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
      when :connected
        unless origin_connected?
          errors.add(:origin_status, "must be '#{CONNECTED_STATUS}' when #{self.class.name} is #{state}")
        end
        unless destination_connected?
          errors.add(:destination_connected, "must be '#{CONNECTED_STATUS}' when #{self.class.name} is #{state}")
        end
      when :disconnected
        if origin_connected? && destination_connected?
          errors.add(:base, "Both origin and destination can't be '#{CONNECTED_STATUS}' when #{self.class.name} is #{state}")
        end
      when :ended
        validate_actor_and_timestamp_exist :end
      when :merged
        if merged_into_phone_call_id.nil?
          errors.add(:merged_into_phone_call_id, "must specify a phone call when #{self.class.name} is #{state}")
        end
    end
  end

  def set_creator
    self.creator = user unless creator_id.present?
  end

  def set_member_on_task
    if user_id_changed? && phone_call_task.present?
      phone_call_task.update_attributes! member_id: user_id
    end
  end
end
