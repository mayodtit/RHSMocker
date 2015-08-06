class TaskChangeSerializer < ActiveModel::Serializer

  attributes :id, :created_at, :event, :from, :to, :data, :reason, :actor_id

  delegate :actor, :task, to: :object

  def attributes
    if options[:shallow]
      super.tap do |attributes|
        attributes[:actor] = {full_name: actor_full_name}
      end
    else
      super.tap do |attributes|
        attributes[:task] = task.try(:serializer, options.merge(shallow: true))
        attributes[:actor] = actor.try(:serializer, options.merge(shallow: true))
      end
    end
  end

  def actor_full_name
    actor.try(:full_name)
  end
end
