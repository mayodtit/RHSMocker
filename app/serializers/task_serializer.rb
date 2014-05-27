class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at

  has_one :role
  has_one :owner
  has_one :service_type

  def type
    'task'
  end
end
