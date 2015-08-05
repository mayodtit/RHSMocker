class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :creator, class_name: 'Member'
  belongs_to :appointment_template
  has_many :appointment_changes

  attr_accessor :actor_id
  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :creator, :creator_id, :arrival_time, :departure_time, :appointment_template_id, :appointment_template

  validates :user, :provider, :scheduled_at, :creator, presence: true
  after_commit :track_update, on: :update

  def data
    changes = previous_changes.slice(
      :scheduled_at,
      :provider_id
    )
    changes.empty? ? nil : changes
  end

  def track_update
    appointment_changes.create!(actor_id: actor_id, data: data)
  end
end
