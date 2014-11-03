class TaskChangeSerializer < ActiveModel::Serializer

  attributes  :created_at, :event, :from, :to, :data

  def attributes
    if options[:shallow]
      attributes = {
        created_at: object.created_at,
        event: object.event,
        from: object.from,
        to: object.to,
        data: object.data
      }
      attributes[:task] = object.task.try(:serializer, options) if object.respond_to? :task
      attributes[:actor] = object.actor.try(:serializer, options) if object.respond_to? :actor
      attributes
    else
      super.tap do |attributes|
        attributes[:task] = object.task.try(:serializer, options) if object.respond_to? :task
        attributes[:actor] = object.actor.try(:serializer, options) if object.respond_to? :actor
      end
    end
  end
end
