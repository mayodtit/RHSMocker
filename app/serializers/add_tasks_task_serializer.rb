class AddTasksTaskSerializer < TaskSerializer
  attributes :member_id, :subject_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
            subject: object.member.try(:serializer, options),
            creator: object.subject.try(:serializer, options)
        )
      end
    end
  end

  def type
    'no-tasks'
  end
end
