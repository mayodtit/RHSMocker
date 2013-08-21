class ScheduledPhoneCall < ActiveRecord::Base
  belongs_to :user
  belongs_to :phone_call
  has_one :message

  attr_accessible :user, :user_id, :phone_call, :phone_call_id, :message, :scheduled_at

  validates :user, :message, :scheduled_at, presence: true

  delegate :consult, :to => :message
end
