class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  has_many :tasks
  belongs_to :service_template

  attr_accessible :service_template_id, :affirmative_child_id, :negative_child_id, :task_templates, :service_template
  validates :service_template_id, presence: true

  def create_association!(affirmative_child_id, negative_child_id)
    self.affirmative_child_id = affirmative_child_id
    self.negative_child_id = negative_child_id
  end

  def create_deep_copy!(override_service_template=nil, task_template_set=nil)
    new_task_template_set = task_template_set.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'affirmative_child_id', 'negative_child_id').merge(service_template: override_service_template || service_template))
    create_task_templates(task_template_set, new_task_template_set)
    if affirmative_child_id = task_template_set.affirmative_child_id
      child_task_template_set = TaskTemplateSet.find(affirmative_child_id)
      next_task_template_set = child_task_template_set.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'affirmative_child_id', 'negative_child_id').merge(service_template: override_service_template || service_template))
      create_task_templates(child_task_template_set, next_task_template_set)
      new_task_template_set.update_attribute(:affirmative_child_id, next_task_template_set.id) if affirmative_child_id
      create_deep_copy!(nil, child_task_template_set)
    end
  end

  def create_task_templates(task_template_set, new_task_template_set)
    task_template_set.task_templates.each do |tt|
      tt.create_deep_copy!(new_task_template_set)
    end
  end
end
