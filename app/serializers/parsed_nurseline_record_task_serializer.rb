class ParsedNurselineRecordTaskSerializer < TaskSerializer
  attributes :parsed_nurseline_record_id

  def attributes
    if options[:shallow]
      super
    else
      super.tap do |attributes|
        attributes.merge!(
          subject: object.member.try(:serializer, options),
          subject_id: object.member.try(:id)
        )
      end
    end
  end

  def type
    'parsed-nurseline-record'
  end
end
