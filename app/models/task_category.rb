class TaskCategory < ActiveRecord::Base
  has_many :tasks
  has_many :task_templates

  attr_accessible :task_template_id, :task_id, :title, :description, :priority_weight

  validates :title, :priority_weight presence: true
end
