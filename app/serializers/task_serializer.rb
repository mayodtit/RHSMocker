class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at,
             :owner_id, :service_type_id, :triage_state

  def attributes
    if options[:shallow]
      {
        id: object.id,
        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type,
        member: object.member.try(:serializer, options),
        triage_state: triage_state
      }
    else
      super.tap do |attributes|
        attributes.merge!(
          member: object.member.try(:serializer, options.merge(include_nested_information: true)),
          owner: object.owner.try(:serializer, options),
          service_type: object.service_type
        )
      end
    end
  end

  def type
    'task'
  end

  def triage_state
    'needs response'
  end
end
