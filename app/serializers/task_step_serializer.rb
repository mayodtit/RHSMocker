class TaskStepSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :description, :ordinal, :completed
end
