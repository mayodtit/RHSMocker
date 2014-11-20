class MessageMemberTaskSerializer < TaskSerializer
  attributes :member_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
            subject: object.member.try(:serializer, options)
        )
      end
    end
  end

  def type
    'message-member'
  end
end
