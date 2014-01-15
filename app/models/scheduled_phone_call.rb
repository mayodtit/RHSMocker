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
                  :assignor_id, :assignor, :assigned_at,
                  :booker_id, :booker, :booked_at,
                  :starter_id, :starter, :started_at,
                  :canceler_id, :canceler, :canceled_at,
                  :ender_id, :ender, :ended_at,
                  :scheduled_duration_s

  accepts_nested_attributes_for :message

  validates :scheduled_at, presence: true

  def user_confirmation_calendar_event
    # TODO: Copy needs to be updated
    RiCal.Event do |event|
      event.summary = 'Scheduled phone call with Better'
      event.description = 'Your Personal Health Assistant will call you at this time'
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = user.phone || 'TBD'
      event.attendee = user.email
      event.organizer = 'noreply@getbetter.com'
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
1) Click or copy this link into your browser: #{CARE_URL_PREFIX}/scheduled_phone_call/#{id}
2) Take three deep breaths...
      eos
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = user.phone || 'TBD'
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
    UserMailer.scheduled_phone_call_cp_assigned_email(self).deliver
  end

  def notify_user_confirming_call
    UserMailer.scheduled_phone_call_member_confirmation_email(self).deliver
  end

  def notify_owner_confirming_call
    UserMailer.scheduled_phone_call_cp_confirmation_email(self).deliver
  end

  state_machine initial: :unassigned do
    event :assign do
      transition :unassigned => :assigned
    end

    event :book do
      transition :assigned => :booked
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

    before_transition :unassigned => :assigned do |scheduled_phone_call, transition|
      scheduled_phone_call.assignor = transition.args.first
      scheduled_phone_call.owner = transition.args.second || transition.args.first
      scheduled_phone_call.assigned_at = Time.now
    end

    after_transition :unassigned => :assigned do |scheduled_phone_call, transition|
      scheduled_phone_call.notify_owner_of_assigned_call
    end

    before_transition :assigned => :booked do |scheduled_phone_call, transition|
      scheduled_phone_call.booker = transition.args.first
      scheduled_phone_call.user = transition.args.second || transition.args.first
      scheduled_phone_call.booked_at = Time.now

      # NOTE: Take consult as an argument once scheduled calls have multiple uses.
      unless scheduled_phone_call.message
        consult = Consult.create!(
          title: DEFAULT_CONSULT_TITLE,
          initiator: scheduled_phone_call.user,
          subject: scheduled_phone_call.user,
          add_user: scheduled_phone_call.user
        )

        message = Message.create!(
          user: scheduled_phone_call.owner || Member.robot,
          consult: consult,
          scheduled_phone_call: scheduled_phone_call
        )
      end
    end

    after_transition :assigned => :booked do |scheduled_phone_call, transition|
      scheduled_phone_call.notify_user_confirming_call
      scheduled_phone_call.notify_owner_confirming_call
    end

    before_transition any => :started do |scheduled_phone_call, transition|
      scheduled_phone_call.starter = transition.args.first
      scheduled_phone_call.owner = transition.args.first
      scheduled_phone_call.started_at = Time.now
    end

    before_transition any => :canceled do |scheduled_phone_call, transition|
      scheduled_phone_call.canceler = transition.args.first
      scheduled_phone_call.canceled_at = Time.now
      scheduled_phone_call.disabled_at = Time.now
    end

    before_transition any => :ended do |scheduled_phone_call, transition|
      scheduled_phone_call.ender = transition.args.first
      scheduled_phone_call.ended_at = Time.now
    end
  end
end
