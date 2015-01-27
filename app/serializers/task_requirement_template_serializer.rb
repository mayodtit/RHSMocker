class TaskRequirementTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_template_id, :title, :description
end
