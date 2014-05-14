class ParsedNurselineRecordTaskSerializer < TaskSerializer
  attributes :parsed_nurseline_record_id

  has_one :member

  def type
    'parsed-nurseline-record'
  end
end
