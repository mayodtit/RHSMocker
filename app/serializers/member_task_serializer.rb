class MemberTaskSerializer < TaskSerializer
  attributes :member_id, :subject_id

  def attributes
    if options[:shallow]
      super
    elsif options[:for_subject]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
          subject: object.subject.try(:serializer, options.merge(shallow: true)),
          creator: object.creator.try(:serializer, options.merge(shallow: true))
        )
      end
    end
  end

  def type
    'member'
  end
end
