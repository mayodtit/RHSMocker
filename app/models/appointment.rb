class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'

  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at

  validates :user, :provider, :scheduled_at, presence: true
end
