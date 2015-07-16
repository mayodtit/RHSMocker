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

  def create_deep_copy!(override_service_template=nil)
    new_task_template_set = self.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'affirmative_child_id', 'negative_child_id').merge(service_template: override_service_template || service_template))
    task_templates.each do |tt|
      tt.create_deep_copy!(new_task_template_set)
    end
  end
end
