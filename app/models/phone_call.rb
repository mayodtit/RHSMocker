class PhoneCall < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  has_one :message
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id, :message_attributes

  validates :user, :message, presence: true

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message
end
