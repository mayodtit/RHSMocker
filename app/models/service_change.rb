class ServiceChange < ActiveRecord::Base
  belongs_to :service
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash
  attr_accessible :service, :service_id, :created_at, :event, :from, :to,
                  :actor, :actor_id, :data, :reason

  validates :service, :actor, presence: true

  before_validation :set_created_at

  def set_created_at
    self.created_at = Time.now unless self.created_at
  end
end
