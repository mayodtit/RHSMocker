class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type

  has_one :role
  has_one :owner

  def type
    'task'
  end
end