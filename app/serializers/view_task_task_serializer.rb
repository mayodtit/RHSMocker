class ViewTaskTaskSerializer < TaskSerializer

  attributes :member_id, :assigned_task_id, :assignor_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
            assigned_task: object.assigned_task.try(:serializer, options.merge(for_task: true)),
            member: object.member.try(:serializer, options.merge(shallow: true)),
            assignor: object.assignor.try(:serializer, options.merge(shallow: true))
        )
      end
    end
  end

  def type
    'view-task'
  end
end
