class AddTasksTaskSerializer < TaskSerializer
  attributes :member_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
            member: object.member.try(:serializer, options)
        )
      end
    end
  end

  def type
    'add-tasks'
  end
end
