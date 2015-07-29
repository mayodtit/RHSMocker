class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :creator, class_name: 'Member'
  has_many :appointment_changes, order: 'created_at DESC'

  attr_accessor :actor_id, :reason
  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :creator, :creator_id, :reason

  validates :user, :provider, :scheduled_at, :creator, presence: true
  after_commit :track_update, on: :update

  def data
    changes = previous_changes.slice(
      :creator_id,
      :created_at
    )
    changes.empty? ? nil : changes
  end

  def track_update
    _data = data
    appointment_changes.create!(actor_id: actor_id, event: 'update', data: _data, reason: reason)
  end
end
