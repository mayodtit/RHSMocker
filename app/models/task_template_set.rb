class TaskTemplateSet < ActiveRecord::Base
  has_many :task_templates
  belongs_to :service_template

  attr_accessible :result, :service_template_id, :parent_id

end
