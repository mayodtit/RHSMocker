class TaskStepChange < ActiveRecord::Base
  belongs_to :task_step, inverse_of: :task_step_changes
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash

  attr_accessible :task_step, :task_step_id, :actor, :actor_id, :data

  validates :task_step, :actor, :data, presence: true
end
