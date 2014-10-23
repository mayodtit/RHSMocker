class TaskChange < ActiveRecord::Base
  belongs_to :task
  belongs_to :actor, class_name: 'Member'

  attr_accessor :unserialized_data
  attr_accessible :task, :task_id, :created_at, :event, :from, :to,
                  :actor, :actor_id, :data, :unserialized_data

  validates :task, :actor, presence: true

  before_validation :serialize_data
  before_validation :set_created_at

  def set_created_at
    self.created_at = Time.now unless self.created_at
  end

  def serialize_data
    self.data = unserialized_data.to_s if unserialized_data
  end
end
