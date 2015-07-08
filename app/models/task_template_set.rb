class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  belongs_to :service_template

  # parent_id - for the parent TaskTemplateSet
  # affirmative_child_id - for the child if the result is affirmative
  # negative_child_id - for the child if the result is negative
  attr_accessible :result, :service_template_id, :parent_id, :affirmative_child_id, :negative_child_id

  def create_parent_association!(parent_id)
    if self.parent_id.nil?
      self.parent_id = parent_id
    end
  end

  def create_child_association!(affirmative_child_id, negative_child_id)
    if self.affirmative_child_id.nil?
      self.affirmative_child_id = affirmative_child_id
    elsif self.negative_child_id.nil?
      self.negative_child_id = negative_child_id
    end
  end
end
