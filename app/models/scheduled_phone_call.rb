class ScheduledPhoneCall < ActiveRecord::Base
  include SoftDeleteModule
  include ActiveModel::ForbiddenAttributesProtection

  DEFAULT_SCHEDULED_DURATION = 30.minutes
  DEFAULT_CONSULT_TITLE = 'Welcome Call'

  belongs_to :user
  belongs_to :owner, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :booker, class_name: 'Member'
  belongs_to :starter, class_name: 'Member'
  belongs_to :canceler, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :phone_call
  has_one :message, :inverse_of => :scheduled_phone_call
  delegate :consult, :to => :message

  attr_accessible :user, :user_id, :owner, :owner_id, :phone_call, :phone_call_id,
                  :message, :scheduled_at, :message_attributes,
                  :assignor_id, :assignor, :booker_id, :booker,
                  :starter_id, :starter, :canceler_id, :canceler,
                  :ender_id, :ender, :scheduled_duration_s, :state_event,
                  :state, :assigned_at, :callback_phone_number

  accepts_nested_attributes_for :message

  validates :scheduled_at, presence: true
  validates :user, presence: true, if: lambda{|spc| spc.user_id}
  validate :attrs_for_states
  validates :callback_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_blank: false, if: lambda { |spc| spc.user_id }

  after_create :if_assigned_notify_owner
  after_save :set_user_phone_if_missing
  after_save :hold_scheduled_messages

  def user_confirmation_calendar_event
    # TODO: Copy needs to be updated
    RiCal.Event do |event|
      event.summary = 'Welcome call with Better'
      event.description = 'Your Personal Health Assistant will call you at this time.'
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = callback_phone_number || user.phone || 'Call'
      event.attendee = user.email
      event.organizer_property = RiCal::PropertyValue::CalAddress.new(nil,
                                                                      value: 'mailto:noreply@getbetter.com',
                                                                      params: {'CN' => 'Better'})

    end
  end

  def owner_assigned_calendar_event
    RiCal.Event do |event|
      event.summary = 'PLACEHOLDER - Welcome Call'
      event.description = <<-eos
You've been assigned this time to do a Welcome Call with a new Better member. You will be notified by email when a member books this time.
      eos
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = 'TBD'
      event.organizer = 'noreply@getbetter.com'
    end
  end

  def owner_confirmation_calendar_event
    RiCal.Event do |event|
      event.summary = 'Welcome Call'
      event.description = <<-eos
Ready, set, welcome a new member

Prep:
1) Click or copy this link into your browser: #{CARE_URL_PREFIX}/appointments/#{id}
2) Take three deep breaths...
      eos
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = callback_phone_number || user.phone || 'TBD'
      event.organizer = 'noreply@getbetter.com'

      # TODO: Don't think this works for Google Calendar, but it's in the right format.
      the_user = user
      event.alarm do |alarm|
        alarm.action = 'DISPLAY'
        alarm.trigger = '-PT10M'
        alarm.description = "You have a Welcome Call w/#{the_user.full_name} in 10m."
      end
    end
  end

  def scheduled_duration
    scheduled_duration_s.seconds
  end

  def notify_owner_of_assigned_call
    UserMailer.delay.scheduled_phone_call_cp_assigned_email(self)
  end

  def notify_user_confirming_call
    Mails::ScheduledPhoneCallMemberConfirmationJob.create(id)
  end

  def notify_owner_confirming_call
    UserMailer.delay.scheduled_phone_call_cp_confirmation_email(self)
  end

  def assign_pha_to_user!
    unless user.pha
      user.update_attributes!(pha: owner)
    end
  end

  def set_user_phone_if_missing
    if user && !user.phone
      user.phone = callback_phone_number
      user.save!
    end
  end

  def hold_scheduled_messages
    if user.try(:master_consult)
      user.master_consult.scheduled_messages.scheduled.each do |m|
        m.hold!
      end
    end
  end

  private

  def if_assigned_notify_owner
    notify_owner_of_assigned_call if state == 'assigned'
  end

  state_machine initial: :unassigned do
    event :assign do
      transition [:unassigned, :assigned] => :assigned
    end

    event :book do
      transition [:booked, :assigned] => :booked
    end

    event :start do
      transition any - [:ended, :canceled, :started] => :started
    end

    event :cancel do
      transition any - [:ended, :canceled] => :canceled
    end

    event :end do
      transition any - [:ended, :canceled] => :ended
    end

    before_transition [:unassigned, :assigned] => :assigned do |scheduled_phone_call|
      scheduled_phone_call.assigned_at = Time.now
    end

    after_transition [:unassigned, :assigned] => :assigned do |scheduled_phone_call|
      # TODO: Email the old owner that they were reassigned
      scheduled_phone_call.notify_owner_of_assigned_call
    end

    before_transition [:booked, :assigned] => :booked do |scheduled_phone_call|
      scheduled_phone_call.booked_at = Time.now
      scheduled_phone_call.assign_pha_to_user!
    end

    after_transition [:booked, :assigned] => :booked do |scheduled_phone_call|
      scheduled_phone_call.notify_user_confirming_call
      scheduled_phone_call.notify_owner_confirming_call
    end

    before_transition any => :started do |scheduled_phone_call|
      scheduled_phone_call.started_at = Time.now
    end

    before_transition any => :canceled do |scheduled_phone_call|
      scheduled_phone_call.canceled_at = Time.now
      scheduled_phone_call.disabled_at = Time.now
    end

    before_transition any => :ended do |scheduled_phone_call|
      scheduled_phone_call.ended_at = Time.now
    end
  end

  # TODO: Write more comprehensive tests
  def attrs_for_states
    state_sym = state.to_sym

    case state_sym
      when :assigned
        validate_actor_and_timestamp_exist :assign
      when :booked
        validate_actor_and_timestamp_exist :book
      when :started
        validate_actor_and_timestamp_exist :start
      when :canceled
        validate_actor_and_timestamp_exist :cancel
        if disabled_at.nil?
          errors.add(:user_id, "must be present when #{self.class.name} is canceled")
        end
      when :ended
        validate_actor_and_timestamp_exist :end
    end

    if state_sym != :unassigned && state_sym != :canceled
      if owner_id.nil?
        errors.add(:owner_id, "must be present when #{self.class.name} is #{state}")
      end
    end

    unless %i(unassigned assigned canceled).include? state_sym
      if user_id.nil?
        errors.add(:user_id, "must be present when #{self.class.name} is #{state}")
      end
      # TODO: Put this back in when we properly do appointments
      # if message.nil?
      #   errors.add(:message, "must be present when #{self.class.name} is #{state}")
      # end
    end
  end
end
