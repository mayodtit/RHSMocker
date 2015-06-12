class ScheduledPhoneCall < ActiveRecord::Base
  include SoftDeleteModule
  include ActiveModel::ForbiddenAttributesProtection

  DEFAULT_SCHEDULED_DURATION = 30.minutes
  DEFAULT_CONSULT_TITLE = 'Welcome Call'

  belongs_to :user
  belongs_to :owner, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :booker, class_name: 'Member'
  belongs_to :canceler, class_name: 'Member'
  belongs_to :ender, class_name: 'Member'
  belongs_to :phone_call
  belongs_to :reminder_scheduled_message, class_name: 'ScheduledMessage'
  has_one :message, :inverse_of => :scheduled_phone_call
  has_one :welcome_call_task, inverse_of: :scheduled_phone_call
  delegate :consult, :to => :message

  attr_accessible :user, :user_id, :owner, :owner_id, :phone_call, :phone_call_id,
                  :message, :scheduled_at, :message_attributes,
                  :assignor_id, :assignor, :booker_id, :booker,
                  :canceler_id, :canceler,
                  :ender_id, :ender, :scheduled_duration_s, :state_event,
                  :state, :assigned_at, :callback_phone_number,
                  :reminder_scheduled_message, :reminder_scheduled_message_id

  accepts_nested_attributes_for :message

  validates :scheduled_at, presence: true
  validates :user, presence: true, if: lambda{|spc| spc.user_id}
  validates :reminder_scheduled_message, presence: true, if: ->(s){s.reminder_scheduled_message_id}
  validate :presence_of_actor_and_timestamp
  validate :not_already_booked
  validate :presence_of_owner_id
  validate :presence_of_user_id
  validates :callback_phone_number, format: PhoneNumber::VALIDATION_REGEX, allow_blank: false, if: lambda { |spc| spc.user_id }
  validate :scheduled_at_during_on_call

  after_create :if_assigned_notify_owner
  after_save :set_user_phone_if_missing

  def self.assigned
    where(state: :assigned)
  end

  def self.in_period(start_time, end_time)
    where('scheduled_at > ?', start_time).where('scheduled_at < ?', end_time)
  end

  def user_confirmation_calendar_event
    RiCal.Event do |event|
      event.summary = "Your call with #{pha_full_name}"
      event.description = "#{pha_full_name} will call you at #{callback_phone_number}."
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = callback_phone_number || user.phone || 'Call'
      event.attendee = user.email
      event.organizer_property = RiCal::PropertyValue::CalAddress.new(nil,
                                                                      value: 'mailto:noreply@getbetter.com',
                                                                      params: {'CN' => 'Better'})
    end
  end

  def pha_full_name
    user.pha.full_name
  end

  def create_task
    if self.welcome_call_task
      self.welcome_call_task.update_task!
    elsif self.assignor && self.booker
      WelcomeCallTask.create_task! self
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
    end
  end

  def create_reminder
    return unless template = MessageTemplate.find_by_name('Welcome Call Reminder')
    if send_in_morning?
      # scheduled today or tomorrow, send reminder in the morning on the day
      publish_at = scheduled_at.pacific.on_call_start_oclock
      day = 'today'
    elsif within_2_hours?
      # scheduled in the future, not today or tomorrow, send reminder the day before
      publish_at = 1.business_day.before(scheduled_at.pacific).pacific.on_call_start_oclock
      day = scheduled_at.pacific.strftime('%A')
    else
      return
    end
    update_attributes!(reminder_scheduled_message: template.create_scheduled_message(owner,
                                                                                     user.master_consult,
                                                                                     publish_at,
                                                                                     'day' => day))
  end

  def send_in_morning?
    (scheduled_at_now? || within_a_day?) && within_2_hours?
  end

  def within_2_hours?
    current_time < (scheduled_at - 2.hours)
  end

  def scheduled_at_now?
    current_date == scheduled_at.pacific.to_date
  end

  def within_a_day?
    current_date >= 1.business_day.before(scheduled_at.pacific).to_date
  end

  def current_date
    @current_date ||= current_time.pacific.to_date
  end

  def current_time
    @current_time ||= Time.now
  end

  def reschedule_reminder
    if reminder_scheduled_message &&
       !(reminder_scheduled_message.state?(:sent) ||
         reminder_scheduled_message.state?(:canceled))
      reminder_scheduled_message.cancel
    end
    create_reminder
  end

  WELCOME_CALL_SURVEY_URL = 'https://docs.google.com/a/getbetter.com/forms/d/1kf2J2IzcZedMRzucOSOxHaliBAt4nnH1vTWOmeRXDWQ/viewform'

  def append_welcome_call_survey_to_member_notes
    if user.try(:onboarding_group).try(:mayo_pilot?)
      user.build_user_information unless user.user_information
      user.user_information.update_attributes(notes: WELCOME_CALL_SURVEY_URL + "\n\n" + (user.user_information.notes || ''))
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
      if Metadata.new_onboarding_flow?
        mt = MessageTemplate.find_by_name 'Confirm Welcome Call'
        mt.create_message(Member.robot, scheduled_phone_call.user.master_consult, true, true) if mt
      else
        mt = MessageTemplate.find_by_name 'Confirm Welcome Call OLD'
        mt.create_message(Member.robot, scheduled_phone_call.user.master_consult, true, true) if mt
      end
      scheduled_phone_call.create_task
    end

    after_transition :assigned => :booked do |scheduled_phone_call|
      scheduled_phone_call.create_reminder
      scheduled_phone_call.append_welcome_call_survey_to_member_notes
    end

    after_transition :booked => :booked do |scheduled_phone_call|
      scheduled_phone_call.reschedule_reminder
    end

    before_transition any => :canceled do |scheduled_phone_call|
      scheduled_phone_call.canceled_at = Time.now
    end

    before_transition any => :ended do |scheduled_phone_call|
      scheduled_phone_call.ended_at = Time.now
    end
  end

  def presence_of_actor_and_timestamp
    if assigned?
      validate_actor_and_timestamp_exist :assign
    elsif booked?
      validate_actor_and_timestamp_exist :book
    elsif canceled?
      validate_actor_and_timestamp_exist :cancel
    elsif ended?
      validate_actor_and_timestamp_exist :end
    end
  end

  def not_already_booked
    if !unassigned? && scheduled_call?
      errors.add(:scheduled_at, "is already booked for #{owner.full_name}.")
    end
  end

  def scheduled_call?
    phone_calls = self.class.where(self.class.arel_table[:id].not_eq(id))
    phone_calls.where(scheduled_at: scheduled_at, owner_id: owner_id).any?
  end

  def presence_of_owner_id
    if !unassigned? && !canceled? && owner_id.nil?
      errors.add(:owner_id, "must be present when #{self.class.name} is #{state}")
    end
  end

  def presence_of_user_id
    if !unassigned? && !assigned? && !canceled? && user_id.nil?
      errors.add(:user_id, "must be present when #{self.class.name} is #{state}")
    end
  end

  def scheduled_at_during_on_call
    if scheduled_at && (assigned? || unassigned?) && !Role.pha.during_on_call?(scheduled_at)
      errors.add(:scheduled_at, "must be weekdays between #{ON_CALL_START_HOUR}AM and #{ON_CALL_END_HOUR % 12}PM")
    end
  end
end
