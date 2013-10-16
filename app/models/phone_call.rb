class PhoneCall < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  has_one :message, :inverse_of => :phone_call
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number

  validates :user, :message, :destination_phone_number, presence: true

  # TODO - remove this fake job when nurseline is built
  after_create :schedule_phone_call_summary

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message

  private

  def schedule_phone_call_summary
    PhoneCallSummaryJob.new.queue_summary(user.id, consult.id)
  end
end
