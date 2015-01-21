class TaskRequirement < ActiveRecord::Base
  belongs_to :task
  belongs_to :task_requirement_template

  attr_accessible :task_requirement_template_id, :task_id, :title, :description, :completed

  validates :task_requirement_template, :title, presence: true


end
