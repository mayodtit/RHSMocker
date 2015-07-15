class TaskTemplateSetSerializer < ActiveModel::Serializer
  attributes :id, :service_template_id, :affirmative_child_id, :negative_child_id
end
