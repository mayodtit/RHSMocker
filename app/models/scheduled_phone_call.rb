class ScheduledPhoneCall < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :user
  belongs_to :phone_call
  has_one :message, :inverse_of => :scheduled_phone_call

  attr_accessible :user, :user_id, :phone_call, :phone_call_id, :message, :scheduled_at,
                  :message_attributes

  validates :user, :scheduled_at, presence: true

  accepts_nested_attributes_for :message

  after_create :notify_user

  delegate :consult, :to => :message

  def calendar_event
    RiCal.Event do |event|
      event.summary = 'Scheduled phone call with Better'
      event.description = 'Your Personal Health Assistant will call you at this time'
      event.dtstart = scheduled_at
      event.dtend = scheduled_at + 30.minutes
      event.location = user.phone || '555-555-5555'
      event.attendee = user.email
      event.organizer = 'noreply@getbetter.com'
    end
  end

  private

  def notify_user
    UserMailer.scheduled_phone_call_email(self).deliver
  end
end
