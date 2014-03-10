class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at

  has_one :role
end