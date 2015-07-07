class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  belongs_to :service_template

  # parent_id - for the parent TaskTemplateSet
  # affirmative_child_id - for the child if the result is affirmative
  # negative_child_id - for the child if the result is negative
  attr_accessible :result, :service_template_id, :parent_id, :affirmative_child_id, :negative_child_id

end
