class TaskChange < ActiveRecord::Base
  belongs_to :task
  belongs_to :actor, class_name: 'Member'

  attr_accessible :task, :task_id, :created_at, :event, :from, :to,
                  :actor, :actor_id, :data

  validates :task, :actor, presence: true

  before_validation :set_created_at

  def set_created_at
    self.created_at = Time.now unless self.created_at
  end
end
