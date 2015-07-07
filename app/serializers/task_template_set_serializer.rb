class TaskTemplateSetSerializer < ActiveModel::Serializer
  attributes :id, :result, :service_template_id, :parent_id, :affirmative_child_id, :negative_child_id
end
