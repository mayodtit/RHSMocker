class TaskTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :service_template_id,:name, :title, :description, :time_estimate, :service_ordinal, :task_guides

end