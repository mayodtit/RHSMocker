class AppointmentTemplate < ActiveRecord::Base
  has_many :system_event_templates

  attr_accessible :name, :description, :title, :scheduled_at
  validates :name, :title, presence: true
end
