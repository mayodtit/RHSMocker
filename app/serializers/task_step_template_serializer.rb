class TaskStepTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_template_id, :description, :ordinal, :details,
             :template

  has_many :data_field_templates
end
