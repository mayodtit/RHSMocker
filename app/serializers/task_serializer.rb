class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at,
             :owner_id, :service_type_id, :triage_state, :member_id, :day_priority

  def attributes
    if options[:shallow]
      attributes = {
        id: object.id,
        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type,
        triage_state: triage_state,
        member_id: member_id,
        day_priority: object.day_priority
      }
      attributes[:member] = object.member.try(:serializer, options) if object.respond_to? :member
      attributes
    elsif options[:for_subject]
      attributes = {
        id: object.id,
        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type,
        service_type: object.service_type,
        owner: object.owner.try(:serializer, options.merge(shallow: true))
      }
      attributes[:task_guides] = object.task_guides.try(:serializer, options) if object.respond_to? :task_guides
    elsif options[:for_task]
      attributes = {
        id: object.id,

        title: object.title,
        state: object.state,
        due_at: object.due_at,
        created_at: object.created_at,
        type: type,
        service_type: object.service_type,
        description: object.description,
        day_priority: object.day_priority
      }
      attributes[:task_guides] = object.task_guides.try(:serializer, options) if object.respond_to? :task_guides
      attributes
    else
      super.tap do |attributes|
        attributes.merge!(
          owner: object.owner.try(:serializer, options),
          service_type: object.service_type
        )
        attributes[:task_changes] = object.task_changes.try(:serializer, options.merge(shallow: true)) if object.respond_to? :task_changes
        attributes[:task_guides] = object.task_guides.try(:serializer, options) if object.respond_to? :task_guides
        attributes[:member] = object.member.try(:serializer, options.merge(include_nested_information: true)) if object.respond_to? :member
      end
    end
  end


  def type
    'task'
  end

  def triage_state
    '-'
  end
end
