class TaskTemplateExpertise < ActiveRecord::Base
  belongs_to :task_template
  belongs_to :expertise

  attr_accessible :task_template, :task_template_id, :expertise, :expertise_id

  validates :task_template, :expertise, presence: true
  validates :expertise_id, uniqueness: {scope: :task_template_id}
end
