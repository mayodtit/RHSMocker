class TaskTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :service_template_id, :name, :title, :description, :time_estimate,
             :service_ordinal, :queue, :task_category_id, :expertise_id, :task_template_set_id

  has_one :modal_template
  has_one :task_category
  has_one :expertise
  has_many :task_step_templates
end
