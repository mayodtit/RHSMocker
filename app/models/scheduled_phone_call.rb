class ScheduledPhoneCall < ActiveRecord::Base
  include SoftDeleteModule
  include ActiveModel::ForbiddenAttributesProtection

  DEFAULT_SCHEDULED_DURATION = 30.minutes

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
                  :message, :scheduled_at, :message_attributes, :state_event,
                  :assignor_id, :assignor, :assigned_at,
                  :booker_id, :booker, :booked_at,
                  :starter_id, :starter, :started_at,
                  :canceler_id, :canceler, :canceled_at,
                  :ender_id, :ender, :ended_at,
                  :scheduled_duration_s

  accepts_nested_attributes_for :message

  validates :scheduled_at, presence: true

  def calendar_event
    RiCal.Event do |event|
      event.summary = 'Scheduled phone call with Better'
      event.description = 'Your Personal Health Assistant will call you at this time'
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + scheduled_duration
      event.location = user.phone || '555-555-5555'
      event.attendee = user.email
      event.organizer = 'noreply@getbetter.com'
    end
  end

  def scheduled_duration
    scheduled_duration_s.seconds
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

    before_transition :assigned => :booked do |scheduled_phone_call, transition|
      scheduled_phone_call.booker = transition.args.first
      scheduled_phone_call.user = transition.args.second || transition.args.first
      scheduled_phone_call.booked_at = Time.now
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

  private

  def notify_user
    UserMailer.scheduled_phone_call_email(self).deliver
  end
end
