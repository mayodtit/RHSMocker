class AppointmentChange < ActiveRecord::Base
  belongs_to :appointment
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash

  attr_accessible :appointment, :appointment_id, :actor, :actor_id, :data, :reason

  validates :appointment, :actor, presence: true
end
