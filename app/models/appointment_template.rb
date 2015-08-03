class AppointmentTemplate < ActiveRecord::Base
  attr_accessible :name, :description, :title, :scheduled_at
  validates :name, :title, presence: true
end
