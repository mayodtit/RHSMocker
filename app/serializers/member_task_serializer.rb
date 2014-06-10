class MemberTaskSerializer < TaskSerializer
  attributes :member_id, :subject_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
          subject: object.subject.try(:serializer, options),
          creator: object.creator.try(:serializer, options)
        )
      end
    end
  end

  def type
    'member'
  end
end
