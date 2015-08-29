class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  belongs_to :service_template
  belongs_to :affirmative_child, class_name: 'TaskTemplateSet'
  belongs_to :negative_child, class_name: 'TaskTemplateSet'

  attr_accessible :service_template_id, :affirmative_child_id, :negative_child_id, :task_templates, :service_template, :affirmative_child, :negative_child
  validates :service_template, presence: true

  def create_deep_copy!(new_service_template)
    new_task_template_set = create_task_template_set!(new_service_template)
    call_task_template_deep_copy!(new_task_template_set)
    new_task_template_set.update_attributes(affirmative_child: affirmative_child.create_deep_copy!(new_service_template)) if affirmative_child
    new_task_template_set.update_attributes(negative_child: negative_child.create_deep_copy!(new_service_template)) if negative_child
    new_task_template_set
  end

  def create_task_template_set!(new_service_template)
    self.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'affirmative_child_id', 'negative_child_id').merge(service_template: new_service_template))
  end

  def call_task_template_deep_copy!(new_task_template_set)
    task_templates.each do |tt|
      tt.create_deep_copy!(new_task_template_set)
    end
  end
end
