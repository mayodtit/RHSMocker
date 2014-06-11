class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at,
             :owner_id, :service_type_id

  def attributes
    if options[:shallow]
      {
        id: object.id,
        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type,
        member: object.member.try(:serializer, options)
      }
    else
      super.tap do |attributes|
        attributes.merge!(
          member: object.member.try(:serializer, options),
          owner: object.owner.try(:serializer, options),
          service_type: object.service_type
        )
      end
    end
  end

  def type
    'task'
  end
end
