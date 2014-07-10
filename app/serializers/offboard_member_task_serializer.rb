class OffboardMemberTaskSerializer < TaskSerializer
  attributes :member_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
          creator: object.creator.try(:serializer, options)
        )
      end
    end
  end

  def type
    'offboard'
  end
end