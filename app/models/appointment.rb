class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :owner, class_name: 'Member'
  belongs_to :creator, class_name: 'Member'
  has_many :appointment_changes, order: 'created_at DESC'

  attr_accessor :actor_id
  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :owner_id, :creator_id, :reason

  validates :user, :provider, :scheduled_at, presence: true
  after_commit :track_update, on: :update

  def actor_id
    @actor_id ||= if @actor_id.nil?
                    if owner_id.nil?
                      creator_id
                    else
                      owner_id
                    end
                  else
                    @actor_id
                  end
  end

  def data
    changes = previous_changes
    changes.empty? ? nil : changes
  end

  def track_update
    _data = data
    AppointmentChange.create! appointment: self, actor_id: self.actor_id, event: 'update', data: _data, reason: reason
  end
end
