class TaskChangeSerializer < ActiveModel::Serializer

  attributes  :created_at, :event, :from, :to, :data

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes[:task] = object.task.try(:serializer, options) if object.respond_to? :task
        attributes[:actor] = object.actor.try(:serializer, options) if object.respond_to? :actor
      end
    end
  end
end
