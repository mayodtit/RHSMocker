class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at,
             :owner_id, :service_type_id

  has_one :member
  has_one :owner
  has_one :service_type

  def attributes
    if options[:shallow]
      {
        id: object.id,
        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type
      }
    else
      super
    end
  end

  def type
    'task'
  end
end
