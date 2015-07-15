class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  has_many :tasks, through: :task_templates
  belongs_to :service_template

  attr_accessible :result, :service_template_id, :affirmative_child_id, :negative_child_id, :task_templates
  validates :service_template_id, presence: true

  def create_association!(affirmative_child_id, negative_child_id)
    self.affirmative_child_id = affirmative_child_id
    self.negative_child_id = negative_child_id
  end
end
