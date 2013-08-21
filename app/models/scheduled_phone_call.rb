class ScheduledPhoneCall < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :user
  belongs_to :phone_call
  has_one :message, :inverse_of => :scheduled_phone_call

  attr_accessible :user, :user_id, :phone_call, :phone_call_id, :message, :scheduled_at,
                  :message_attributes

  validates :user, :message, :scheduled_at, presence: true

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message

  def self.message_params(user, consult, nested_params=nil)
    params = {user: user, consult: consult, text: 'Scheduled phone call!'}
    params.merge!(:scheduled_phone_call_attributes => nested_params.merge!(:user => user)) if nested_params
    params
  end
end
