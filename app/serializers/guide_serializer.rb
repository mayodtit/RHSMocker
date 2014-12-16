class GuideSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_template_id, :description
end
