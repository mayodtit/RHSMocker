class PhoneCall < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  has_one :message
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id

  validates :user, presence: true
end
