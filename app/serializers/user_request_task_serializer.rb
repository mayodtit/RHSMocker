class UserRequestTaskSerializer < TaskSerializer
  attributes :user_request_id, :member_id, :subject_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
          subject: object.subject.try(:serializer, options)
        )
      end
    end
  end

  def type
    'user-request'
  end
end
