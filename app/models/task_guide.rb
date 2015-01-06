class TaskGuide < ActiveRecord::Base
  belongs_to :task_template

  attr_accessible :task_template, :task_template_id, :title, :description

  validates :task_template, :title, presence: true
end
