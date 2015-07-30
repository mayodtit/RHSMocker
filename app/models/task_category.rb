class TaskCategory < ActiveRecord::Base
  has_many :tasks
  has_many :task_templates

  attr_accessible :title, :description, :priority_weight

  validates :title, :description, :priority_weight, presence: true
end
